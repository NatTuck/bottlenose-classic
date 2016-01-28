class MainController < ApplicationController
  def index
    @user = User.new

    if current_user
      redirect_to courses_path
    end
  end

  def about
    add_root_breadcrumb
    add_breadcrumb "About"
  end
end
