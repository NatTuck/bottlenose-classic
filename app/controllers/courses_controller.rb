require 'csv'

class CoursesController < ApplicationController
  before_filter :find_course, 
    :except => [:index, :new, :create]
  before_filter :require_course_permission, 
    :except => [:index, :new, :create, :show]
  before_filter :require_logged_in_user
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

  def bulk_add
    if request.post?
      num_added = 0

      if params[:emails]
        text = params[:emails]
        text.gsub(/;,/, ' ')

        emails = text.split(/\s+/)
        emails.each do |ee|
          next unless ee =~ /\@.*\./
          prefix, _ = ee.split('@')
          @course.add_registration(prefix.downcase, ee)
          num_added += 1
        end
      end

      if params[:csv]
        csv = params[:csv]
        CSV.parse(csv.read) do |line|
          next unless line[1] =~ /\@.*\./
          @course.add_registration(line[0], line[1])
          num_added += 1
        end 
      end
    end

    flash[:notice] = "Added #{num_added} students."
  end

  def index
    if @logged_in_user.site_admin?
      @course  = Course.new
    end
      
    @courses = @logged_in_user.courses.order(:name)
    @courses_by_term = {}
    Term.all.each do |term|
      @courses_by_term[term.id] = @courses.find_all {|cc| 
        cc.term_id == term.id }
    end

    @courses_no_term = @courses.find_all {|cc| cc.term_id.nil? }

    @alls = Course.order(:name) - @courses
    @all_by_term = {}

    @alls_by_term = {}
    Term.all.each do |term|
      @alls_by_term[term.id] = @alls.find_all {|cc| 
        cc.term_id == term.id }
    end

    @alls_no_term = @alls.find_all {|cc| cc.term_id.nil? }
  end

  def show
    @registration = @logged_in_user.registration_for(@course)
    @registration ||= "javascript:alert('Not registered.');"

    if @logged_in_user.course_admin?(@course)
      @active_regs = @course.active_registrations.
        sort_by {|rr| rr.user.invert_name.downcase }
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
    @course = Course.new(course_params)
    @course.late_options = [params[:late_penalty], params[:late_repeat], params[:late_maximum]].join(',') unless params[:late_penalty].nil?

    if @course.save
      redirect_to @course, notice: 'Course was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @course.assign_attributes(course_params)
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

  def course_params
    params[:course].permit(:name, :footer, :late_options, :private, 
                           :term_id, :questions_due_time, :sub_max_size)
  end
end
