class ApplicationController < ActionController::Base
  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end
  protect_from_forgery

  before_filter :set_mailer_host

  def add_root_breadcrumb
    clear_breadcrumbs
    add_breadcrumb(fa_icon("home"), :root_path)
  end

  def add_course_breadcrumbs(course)
    add_root_breadcrumb
    add_breadcrumb("Courses", courses_path)
    add_breadcrumb(course.term.name, courses_path)
    add_breadcrumb(course.name, course)
  end

  protected

  def set_mailer_host
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
    ActionMailer::Base.default_url_options[:protocol] = request.protocol
  end

  def show_notice(msg)
    flash[:notice] = msg
  end

  def show_error(msg)
    flash[:error] = msg
  end

  def require_site_admin
    unless current_user && current_user.site_admin?
      show_error "You don't have permission to access that page."
      redirect_to '/courses'
      return
    end
  end

  def find_course
    @course ||= Course.find(params[:course_id])
  end

  def require_course_permission
    find_course

    if current_user.nil?
      show_error "You need to register first"
      redirect_to '/'
      return
    end

    if current_user.course_admin?(@course)
      return
    end

    reg = current_user.registration_for(@course)
    if reg.nil?
      show_error "You're not registered for that course."
      redirect_to courses_url
      return
    end
  end

  def require_student
    find_course

    if current_user.nil?
      show_error "You need to register first"
      redirect_to '/'
      return
    end

    if @course.nil?
      show_error "No such course."
      redirect_to courses_url
      return
    end

    if current_user.site_admin?
      return
    end

    reg = current_user.registrations.where(course_id: @course.id)

    if reg.nil? or reg.empty?
      show_error "You're not registered for that course."
      redirect_to courses_url
      return
    end
  end

  def require_teacher
    find_course

    if current_user.nil?
      show_error "You need to register first"
      redirect_to '/'
      return
    end

    if @course.nil?
      show_error "No such course."
      redirect_to courses_url
      return
    end

    unless current_user.site_admin? or @course.taught_by?(current_user)
      show_error "You're not allowed to go there."
      redirect_to course_url(@course)
      return
    end
  end

  def require_logged_in_user
    if current_user.nil?
      show_error "You need to register first"
      redirect_to '/'
      return
    end
  end
end
