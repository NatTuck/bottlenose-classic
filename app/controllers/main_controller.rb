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
      redirect_to '/'
      return
    end

    session[:user_id] = @user.id
    
    show_notice "Logged in as #{@email}."
    redirect_to '/'
  end
  
  def resend_auth
    @email = params['email'].downcase
    
    # Create site admin on first run.
    if User.count == 0
      @user = User.create(:email => @email, :site_admin => true)
    else 
      @user = User.find_by_email(@email)
    end
    
    if @user.nil?
      show_error "Email address [#{@email}] is not known."
      redirect_to '/'
      return
    end
    
    @user.send_auth_link_email!(root_url)
    
    show_notice "Check your email for your authentication link."
    redirect_to '/'
  end
  
  def logout
    session[:user_id] = nil
    show_notice "You have logged out."
    redirect_to '/'    
  end
end
