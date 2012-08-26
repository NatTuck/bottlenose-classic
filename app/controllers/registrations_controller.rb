class RegistrationsController < ApplicationController
  before_filter :require_teacher, :except => [:show]
  
  def index
    @registrations = Registration.all
  end

  def show
    @registration = Registration.find(params[:id])
  end

  def new
    @registration = Registration.new
  end

  def edit
    @registration = Registration.find(params[:id])
  end

  def create
    @registration = Registration.new(params[:registration])

    if @registration.save
      redirect_to @registration, notice: 'Registration was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @registration = Registration.find(params[:id])

    if @registration.update_attributes(params[:registration])
      redirect_to @registration, notice: 'Registration was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @registration = Registration.find(params[:id])
    @registration.destroy

    redirect_to registrations_url(@course)
  end

  private
  
  def require_teacher
    find_user_session

    @course = Course.find(params[:course_id])
    
    if @course.nil?
      show_error "No such course."
      redirect_to courses_url
    end
    
    unless @logged_in_user.site_admin? or @course.taught_by?(@logged_in_user)
      show_error "You're not allowed to go there."
      redirect_to course_url(@course)
      return
    end
  end
end
