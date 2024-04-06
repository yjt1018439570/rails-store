class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update]

  def show
    # @user is set by the set_user before_action
  end

  def edit
    # @user is set by the set_user before_action
    # This will render the edit form for a user
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "User updated successfully."
      redirect_to @user
    else
      flash.now[:alert] = "User could not be updated."
      render :edit, status: :unprocessable_entity
    end
  end


  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "User created successfully."
      redirect_to users_path
    else
      flash.now[:alert] = "User not created."
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation)
  end
end
