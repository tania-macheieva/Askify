class UsersController < ApplicationController
  before_action :require_login, except: [ :index, :new, :create ]
  before_action :set_user, only: [ :show ]
  before_action :set_current_user, only: [ :edit, :update, :destroy ]

  def index
    @users = User.all

    if params[:search].present?
      search_query = "%#{params[:search].strip.downcase}%"
      @users = @users.where(
        "LOWER(name) LIKE :q OR LOWER(nickname) LIKE :q OR LOWER(position) LIKE :q",
        q: search_query
      )
    end

    @users = @users.order(created_at: :desc)
  end

  def new
    session[:current_time] = Time.now
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
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

  def edit; end

  def update
    purge_avatar_if_requested

    if @user.update(user_params)
      redirect_to root_path, notice: "Successfully user's data updated!"
    else
      flash.now[:alert] = "Errors occurred when trying to save the user."
      render :edit
    end
  end

  def destroy
    @user.destroy
    reset_session
    redirect_to root_path, notice: "The user successfully removed!"
  end

  private

  def require_login
    unless current_user
      redirect_to sign_in_path, alert: "You must be logged in to view user profiles!"
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def set_user
    @user = User.find_by(nickname: params[:nickname])
  end

  def set_current_user
    @user = current_user
    unless @user && @user.nickname == params[:nickname]
      redirect_to root_path, alert: "Access denied."
    end
  end

  def purge_avatar_if_requested
    return unless params.dig(:user, :remove_avatar) == "1"

    @user.avatar.purge if @user.avatar.attached?
    params[:user].delete(:remove_avatar)
  end

  def user_params
    params.require(:user).permit(
      :name, :nickname, :email, :password,
      :password_confirmation, :avatar,
      :github_url, :linkedin_url,
      :education, :experience, :tech_stack,
      :languages, :position, :remove_avatar
    )
  end
end
