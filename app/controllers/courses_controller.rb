class CoursesController < ApplicationController
  before_filter :find_course, :except => [:index, :new, :create]
  before_filter :require_logged_in_user
  before_filter :require_site_admin, :only => [:new, :create, :destroy]
  
  def index
    @courses = Course.all
    @course  = Course.new
  end

  def show
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
    
    if @course.update_attributes(params[:course])
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
