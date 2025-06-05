class SessionsController < ApplicationController
  def new
  end

  def create
    user_params = params.require(:session)

    user = User.find_by(email: user_params[:email])

    if user&.authenticate(user_params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "You successfully signed in!"
    else
      flash.now[:alert] = "Incorrect email or password"
      render :new
    end
  end


  def destroy
    session.delete(:user_id)

    redirect_to root_path, notice: "You successfully signed out!"
  end
end
