class UsersController < ApplicationController
  before_action :set_user, only: [ :show, :edit, :update, :destroy ]

  def index
    @users = User.all.order(created_at: :desc)
  end

  def new
    session[:current_time] = Time.now
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to root_path, notice: "Successfully signed up!"
    else
      flash.now[:alert] = "Incorrectly filled fields!"
      render :new
    end
  end

  def show
    @questions = @user.questions.order(created_at: :desc)
    @received_questions = @user.received_questions.order(created_at: :desc)
    @new_question = Question.new
  end

  def edit
  end

  def update
    if params[:user] && params[:user][:remove_avatar] == "1"
      @user.avatar.purge if @user.avatar.attached?
      params[:user].delete(:remove_avatar)
    end

    if @user.update(user_params)
      redirect_to root_path, notice: "Successfully user's data updated!"
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
    params.require(:user).permit(
      :name, :nickname, :email, :password,
      :password_confirmation, :avatar,
      :github_url, :linkedin_url,
      :education, :experience, :tech_stack, :languages, :position,
      :remove_avatar
    )
  end
end
