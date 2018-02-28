## app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :logged_in_user,  only: %i[index edit update destroy
                                           following followers]
  before_action :correct_user,    only: %i[edit update]
  before_action :admin_user,      only: %i[destroy]

  def index
    if params[:search]
      user = User.search params[:search]
      @users = user.paginate(page: 1)
    else
      @users = User.where(activated: true).paginate(page: params[:page],
                                                    per_page: 20)
    end
  end

  def show
    @user = User.find(params[:id])
    redirect_to(root_url) unless @user.activated?
    @relationship = ArtistRelationship.new
  end

  def new
    redirect_to current_user if logged_in?
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = 'Please check your email to activate your account.'
      redirect_to login_path
    else
      render 'new'
    end
  end

  def edit; end

  def update
    if params[:admin]
      update_admin_attribute
      redirect_to @user
    elsif @user.update_attributes(user_params)
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      flash[:warning] = 'Unsuccessful'
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'User deleted'
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  def update_admin_attribute
    admin_user # make sure the current user is an admin
    @user.toggle! :admin
    if @user.admin
      flash[:success] = "#{@user.name} is now an administrator."
    else
      flash[:info] = "#{@user.name} is no longer an administrator."
    end
  end
end
