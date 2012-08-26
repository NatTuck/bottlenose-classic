class CoursesController < ApplicationController
  before_filter :require_logged_in_user
  before_filter :require_site_admin, :only => [:new, :create, :destroy]
  
  def index
    @courses = Course.all
    @course  = Course.new
  end

  def show
    @course = Course.find(params[:id])
  end

  def new
    @course = Course.new
  end

  def edit
    @course = Course.find(params[:id])
    
    unless @logged_in_user.site_admin? or @course.taught_by?(@logged_in_user)
      show_error "You don't have permission to do that."
      redirect_to course_url(@course)
      return
    end
    
    @registration = Registration.new(teacher: true, course_id: @course.id)
    
    @users_by_id = {}
    User.all.each do |user|
      @users_by_id[user.name] = user.id
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
    @course = Course.find(params[:id])

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
    @course = Course.find(params[:id])
    @course.destroy

    redirect_to courses_url
  end
end
