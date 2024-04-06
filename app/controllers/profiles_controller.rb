class ProfilesController < ApplicationController
  before_action :ensure_authenticated
  before_action :set_user
  before_action :set_profile, only: [:show, :edit, :update]


  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @profile.update(profile_params)
        format.json { render json: { success: true } }
      else
        format.json { render json: { success: false }, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
    redirect_to new_user_session_path unless @user == current_user
  end

  def set_profile
    # Ensure profile exists for the user, if not, create a blank one.
    @profile = @user.profile || @user.create_profile
  end

  def profile_params
    params.require(:profile).permit(:bio, :location, :birthdate)
  end

  private
  def ensure_authenticated
    redirect_to new_user_session_path unless current_user
  end
end
