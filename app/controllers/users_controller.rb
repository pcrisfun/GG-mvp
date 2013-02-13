class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy

  def destroy
    @user = User.find(params[:id])
    @user.gallery.destroy
    @user.destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end

  def show
    @user = User.find(params[:id])
  end

  def new
  	@user = User.new
    @user.birthday = Date.today
  end

  def create
    @user = User.new(params[:user])
    if @user.save #&& @user.deliver_welcome
      sign_in @user
      flash[:success] = "Welcome to the GirlsGuild community!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update_attributes(params[:user]) && @user.deliver_update
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
    @user = current_user
    @users = User.paginate(page: params[:page])
  end

end
