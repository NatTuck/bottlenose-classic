class CoursesController < ApplicationController
  before_filter :find_course, 
    :except => [:index, :new, :create]
  before_filter :require_course_permission, 
    :except => [:index, :new, :create]
  before_filter :require_teacher,    :only => [:export_grades, :edit, :update]
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

    @courses_by_term = {}
    Term.all.each do |term|
      @courses_by_term[term.id] = @courses.find_all {|cc| 
        cc.term_id == term.id }
    end

    @courses_no_term = @courses.find_all {|cc| cc.term_id.nil? }
  end

  def show
    @registration = @logged_in_user.registration_for(@course)
    @registration ||= "javascript:alert('Not registered.');"

    if @logged_in_user.course_admin?(@course)
      @active_regs = @course.active_registrations.
        sort_by {|rr| rr.user.name }
    end
  end

  def new
    @course = Course.new
    @terms = Term.all_sorted
  end

  def edit
    @terms = Term.all_sorted
    @course.questions_due_time ||= Time.local(2000,1,1,0,0) 
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
