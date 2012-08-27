class RegistrationsController < ApplicationController
  before_filter :find_registration, :except => [:index, :new, :create]
  before_filter :require_teacher
  
  def index
    @teacher_reg = Registration.new(course_id: @course.id, teacher: true)
    @student_reg = Registration.new(course_id: @course.id)
  end

  def show
  end

  def new
    # 'new' is unused
    redirect_to @course
    return

    @registration = Registration.new
    @registration.course_id = @course.id
  end

  def edit
  end

  def create
    @registration = Registration.new(params[:registration])

    if @registration.course_id != @course.id
      show_error "Registration does not match course"
      redirect_to @course
      return
    end

    if params[:student_email] and params[:student_name]
      student = User.find_by_email(params[:student_email])
      
      if student.nil?
        student = User.new(name: params[:student_name], email: params[:student_email])
        student.save!

        student.send_auth_link_email!(root_url)
      end

      @registration.user_id = student.id
    end

    if @registration.save
      redirect_to course_registrations_path(@course),
        notice: 'Registration was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    if @registration.update_attributes(params[:registration])
      redirect_to course_registrations_path(@course),
        notice: 'Registration was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @registration.destroy

    redirect_to course_registrations_path(@course)
  end

  private

  def find_course
    @course = Course.find(params[:course_id])
  end
  
  def require_teacher
    find_user_session
    find_course

    if @logged_in_user.nil?
      show_error "You need to log in."
      redirect_to root_url
      return
    end

    if @course.nil?
      show_error "No such course."
      redirect_to courses_url
      return
    end
    
    unless @logged_in_user.site_admin? or @course.taught_by?(@logged_in_user)
      show_error "You're not allowed to go there."
      redirect_to course_url(@course)
      return
    end
  end

  def find_registration
    find_course

    if @course.nil?
      show_error "No such course."
      redirect_to courses_url
      return
    end

    @registration = Registration.find(params[:id])

    if @registration.course_id != @course.id
      show_error "Registration does not match course"
      redirect_to @course
      return
    end
  end
end
