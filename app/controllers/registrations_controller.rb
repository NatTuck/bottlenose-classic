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
