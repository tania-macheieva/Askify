class UsersController < ApplicationController
  before_action :set_user, only: [ :edit, :update, :destroy ]

  def new
    session[:current_time] = Time.now
    @user = User.new
  end

  def create
    user_params

    @user = User.new(user_params)

    if @user.save
      redirect_to root_path, notice: "Successfully signed up!"
    else
      flash.now[:alert] = "Incorrectly filled fields!"
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to root_path, notice: "Successfully user`s data updated!"
    else
      flash.now[:alert] = "Errors occurred when trying to save the user."
      render :edit
    end
  end

  def destroy
    @user.destroy

    session.delete(:user_id)

    redirect_to root_path, notice: "The user successfully removed!"
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :nickname, :email, :password, :password_confirmation, :avatar)
  end
end
