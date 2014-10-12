class UsersController < ApplicationController
  before_filter :require_site_admin
  
  def index
    @users = User.order(:name)
    @user  = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)

    if @user.save
      @user.send_auth_link_email!(root_url)  
      redirect_to @user, notice: 'User was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to users_url
  end
  
  def impersonate
    @user = User.find(params[:id])
    session[:user_id] = @user.id
    show_notice "You are now #{@user.name}"
    redirect_to courses_url
  end

  private

  def user_params
    params[:user].permit(:email, :name, :site_admin, :auth_key)
  end
end
