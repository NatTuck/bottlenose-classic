class UsersController < ApplicationController
  before_filter :require_site_admin, except: [:new, :create, :update]

  def index
    @users = User.order(:name)
    @user  = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
    @terms = Term.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)

    if User.count == 0
      @user.site_admin = true
    else
      @user.site_admin = false
    end

    if @user.save
      @user.send_auth_link_email!

      if current_user.nil?
        redirect_to '/',
          notice: 'User created. Check your email for an authentication link.'
      else
        redirect_to @user, notice: 'User was successfully created.'
      end
    else
      render action: "new"
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      if current_user.site_admin?
        redirect_to @user, notice: 'User was successfully updated.'
      else
        redirect_to '/courses', notice: "Name successfully updated"
      end
    else
      if current_user.site_admin?
        render action: "edit"
      else
        redirect_to '/main/auth',
          alert: "Error updating name: #{@user.errors.full_messages.join('; ')}"
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to users_url
  end

  def impersonate
    raise "TODO"
    @user = User.find(params[:id])
    session[:user_id] = @user.id
    show_notice "You are now #{@user.name}"
    redirect_to courses_url
  end

  private

  def user_params
    if current_user && current_user.site_admin?
      params[:user].permit(:email, :name, :site_admin)
    else
      params[:user].permit(:email, :name)
    end
  end
end
