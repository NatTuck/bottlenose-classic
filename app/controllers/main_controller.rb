class MainController < ApplicationController
  before_filter :find_user_session

  def index
    @user = User.new

    if session[:user_id]
      redirect_to courses_path
    end
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
