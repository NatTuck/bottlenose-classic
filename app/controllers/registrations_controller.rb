class RegistrationsController < ApplicationController
  before_filter :require_teacher, :except => [:show, :submissions_for_assignment]
  before_filter :require_course_permission
  prepend_before_filter :find_registration, :except => [:index, :new, :create]

  def index
    @teacher_reg = Registration.new(course_id: @course.id, teacher: true)
    @student_reg = Registration.new(course_id: @course.id)
  end

  def show
    unless @logged_in_user.course_admin?(@course) or @registration.user.id == @logged_in_user.id
      show_error "I can't let you do that."
      redirect_to @course
      return
    end

    @a_score = @registration.assign_score
    @q_score = @registration.questions_score 
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
        student = User.new(name:  params[:student_name],
                           email: params[:student_email])
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
      redirect_to @registration,
        notice: 'Registration was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @registration.destroy

    redirect_to course_registrations_path(@course)
  end

  def submissions_for_assignment
    @assignment  = Assignment.find(params[:assignment_id])
    @submissions = @assignment.submissions_for(@user)
  end

  private

  def find_registration
    @registration = Registration.find(params[:id])
    @course = @registration.course
    @user   = @registration.user
  end
end
