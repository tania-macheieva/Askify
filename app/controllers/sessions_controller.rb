class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: session_params[:email].downcase.strip)

    if user&.authenticate(session_params[:password])
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

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
