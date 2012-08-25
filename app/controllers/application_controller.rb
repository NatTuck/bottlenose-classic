class ApplicationController < ActionController::Base
  protect_from_forgery

  def find_user_session
    if session['user_id'].nil?
      @user = nil
    else
      @user = User.find(session['user_id'])
    end
  end
  
  def show_notice(msg)
    flash[:notice] = msg
  end

  def show_error(msg)
    flash[:error] = msg
  end
end
