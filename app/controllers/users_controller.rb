class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user_params = params.require(:user).permit(:name, :nickname, :email, :password, :avatar)

    @user = User.new(user_params)

    if @user.save
      redirect_to root_path, notice: "Successfully signed up!"
    else
      flash.now[:alert] = "Incorrectly filled fields!"
      render :new
    end
  end
end
