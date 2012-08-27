class ApplicationController < ActionController::Base
  protect_from_forgery

  protected

  def show_notice(msg)
    flash[:notice] = msg
  end

  def show_error(msg)
    flash[:error] = msg
  end
  
  def find_user_session
    if session['user_id'].nil?
      @logged_in_user = nil
    else
      @logged_in_user = User.find_by_id(session['user_id'])
    end
  end
  
  def require_logged_in_user
    find_user_session
    
    if @logged_in_user.nil?
      show_error "Please log in first."
      redirect_to '/'
      return
    end
  end

  def require_site_admin
    find_user_session
    
    if @logged_in_user.nil?
      show_error "Please log in first."
      redirect_to '/'
      return
    end
    
    unless @logged_in_user.site_admin?
      show_error "You don't have permission to access that page."
      redirect_to '/courses'
      return
    end
  end

  def find_course
    if @course.nil?
      @course = Course.find(params[:course_id])
    end
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
end
