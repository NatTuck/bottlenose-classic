class CoursesController < ApplicationController
  before_filter :find_course, :except => [:index, :new, :create]
  before_filter :require_logged_in_user
  before_filter :require_student,  :except => [:index, :new, :create, :destroy]
  before_filter :require_teacher,    :only => [:export_grades]
  before_filter :require_site_admin, :only => [:new, :create, :destroy]
  
  def export_grades
    @subs = []
    @course.assignments.each do |assignment|
      assignment.best_submissions.each do |sub|
        @subs << sub
      end
    end

    render :formats => [:text]
  end

  def index
    if @logged_in_user.site_admin?
      @courses = Course.order(:name)
      @course  = Course.new
    else
      @courses = @logged_in_user.courses.order(:name)
    end
  end

  def show
    @registration = @logged_in_user.registrations.where(course_id: @course.id).first
    @registration ||= "javascript:alert('Not registered.');"

    if @logged_in_user.course_admin?(@course)
      @student_regs = @course.student_registrations.sort_by {|rr| rr.user.name }
    end
  end

  def new
    @course = Course.new
  end

  def edit
    unless @logged_in_user.site_admin? or @course.taught_by?(@logged_in_user)
      show_error "You don't have permission to do that."
      redirect_to course_url(@course)
      return
    end
  end

  def create
    @course = Course.new(params[:course])
    @course.late_options = [params[:late_penalty], params[:late_repeat], params[:late_maximum]].join(',') unless params[:late_penalty].nil?

    if @course.save
      redirect_to @course, notice: 'Course was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    unless @logged_in_user.site_admin? or @course.taught_by?(@logged_in_user)
      show_error "You don't have permission to do that."
      redirect_to course_url(@course)
      return
    end

    @course.assign_attributes(params[:course])
    @course.late_options = [params[:late_penalty], params[:late_repeat], params[:late_maximum]].join(',') unless params[:late_penalty].nil?

    if @course.save
      redirect_to @course, notice: 'Course was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @course.destroy
    redirect_to courses_url
  end

  def report
    show_notice "All the students are terrible."
    redirect_to @course
  end

  private

  def find_course
    @course = Course.find(params[:id] || params[:course_id])
  end
end
