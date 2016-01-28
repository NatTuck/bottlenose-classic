class RegistrationsController < ApplicationController
  before_filter :require_teacher, :except => [:show, :submissions_for_assignment]
  before_filter :require_course_permission
  before_filter :setup_breadcrumbs
  prepend_before_filter :find_registration, :except => [:index, :new, :create]

  def index
    add_breadcrumb "Registrations"

    @registration = Registration.new(course_id: @course.id)
  end

  def show
    add_breadcrumb "Student Status Report"

    unless current_user.course_admin?(@course) or @registration.user.id == current_user.id
      show_error "I can't let you do that."
      redirect_to @course
      return
    end

    @score = @registration.total_score
  end

  def new
    raise Exception.new("Unused?")
    @registration = Registration.new
  end

  def edit
    add_breadcrumb "Registrations", course_registrations_path(@course)
    add_breadcrumb "Edit Registration"
  end

  def create
    @registration = Registration.new(registration_params)

    name, email = params[:user_name], params[:user_email]
    if name.blank? or email.blank?
      @registration.errors[:base] << "Must provide name and email"
      render action: "new"
      return
    end

    @registration = @course.add_registration(name, email,
                                             @registration.teacher?)

    respond_to do |format|
      unless @registration.save
        render action: "new"
        return
      end

      format.html do
        redirect_to course_registrations_path(@course),
        notice: 'Registration was successfully created.'
      end

      format.js {}
    end
  end

  def update
    if @registration.update_attributes(registration_params)
      redirect_to [:edit, @registration],
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

    add_breadcrumb @assignment.name, @assignment
    add_breadcrumb "Submissions"
  end

  def toggle_show
    @registration.show_in_lists = ! @registration.show_in_lists?
    @registration.save

    @show = @registration.show_in_lists? ? "Yes" : "No"
  end

  private

  def find_registration
    @registration = Registration.find(params[:id])
    @course = @registration.course
    @user   = @registration.user
  end

  def setup_breadcrumbs
    if @course.nil?
      @course = Course.find(param[:course_id])
    end

    add_course_breadcrumbs(@course)
  end

  def registration_params
    params[:registration].permit(:course_id, :teacher, :user_id, :show_in_lists, :tags)
  end
end
