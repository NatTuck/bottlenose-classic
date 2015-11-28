class MainController < ApplicationController
  before_filter :find_user_session
 
  def index
    @user = User.new

    if session[:user_id]
      redirect_to courses_path
    end
  end
  
  def auth
    if params['email'].blank?
      if @logged_in_user.nil?
        redirect_to root_url
      else
        @user = @logged_in_user
      end
      return
    end

    @email = params['email'].downcase
    @key   = params['key']

    @user  = User.find_by_email(@email)

    if @user.nil? or @user.auth_key != @key
      show_error "Authentication failed. Unknown email or bad key."
      session[:user_id] = nil
      redirect_to root_url
      return
    end

    session[:user_id] = @user.id
    find_user_session
    
    show_notice "Logged in as #{@user.name} &lt;#{@user.email}&gt;."
  end
  
  def resend_auth
    @email = params['email'].downcase
    
    # Create site admin on first run.
    if User.count == 0
      @user = User.create(email: @email, name: "admin", site_admin: true)
    else 
      @user = User.find_by_email(@email)
    end
    
    if @user.nil?
      redirect_to root_url, alert: "No user with email #{@email}"
      return
    end
    
    @user.send_auth_link_email!
    
    show_notice "Check your email for your authentication link."
    redirect_to root_url
  end
  
  def logout
    session[:user_id] = nil
    show_notice "You have logged out."
    redirect_to root_url
  end

  def about
    add_root_breadcrumb
    add_breadcrumb "About"
  end
end
