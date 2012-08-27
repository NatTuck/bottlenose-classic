class MainController < ApplicationController
  before_filter :find_user_session, :only => [:index]
  
  def index
  end
  
  def auth
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
    
    show_notice "Logged in as #{@email}."
    
    if @user.site_admin?
      redirect_to users_url
    else
      redirect_to courses_url
    end
  end
  
  def resend_auth
    @email = params['email'].downcase
    
    # Create site admin on first run.
    if User.count == 0
      @user = User.create(:email => @email, :name => "Admin McAdminpants", 
                          :site_admin => true)
    else 
      @user = User.find_by_email(@email)
    end
    
    if @user.nil?
      show_error "Email address [#{@email}] is not known."
      redirect_to root_url
      return
    end
    
    @user.send_auth_link_email!(root_url)
    
    show_notice "Check your email for your authentication link."
    redirect_to root_url
  end
  
  def logout
    session[:user_id] = nil
    show_notice "You have logged out."
    redirect_to root_url
  end
end
