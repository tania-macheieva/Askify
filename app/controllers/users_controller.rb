class UsersController < ApplicationController
  before_action :require_login, except: [ :index, :new, :create ]
  before_action :set_user, only: [ :show ]
  before_action :authorize_user!, only: [ :edit, :update, :destroy ]

  def index
    @users = User.all

    if params[:search].present?
      query = "%#{params[:search].strip.downcase}%"
      @users = @users.where(
        "LOWER(name) LIKE :q OR LOWER(nickname) LIKE :q OR LOWER(position) LIKE :q",
        q: query
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
      redirect_to root_path, notice: "Welcome aboard! You've signed up successfully."
    else
      flash.now[:alert] = "Please check the fields and try again."
      render :new
    end
  end

  def show
    @questions = @user.questions.order(created_at: :desc)
    @received_questions = @user.received_questions.order(created_at: :desc)
    @new_question = Question.new

    if params[:search].present?
      search = params[:search].strip.downcase
      query = "%#{search}%"
      @received_questions = @received_questions.where("LOWER(body) LIKE :q", q: query)
    end
  end

  def edit; end

  def update
    if params.dig(:user, :remove_avatar) == "1"
      @user.avatar.purge if @user.avatar.attached?
    end

    if @user.update(user_params.except(:remove_avatar))
      redirect_to root_path, notice: "Profile updated successfully!"
    else
      flash.now[:alert] = "Oops! Something went wrong."
      render :edit
    end
  end

  def destroy
    @user.destroy
    reset_session
    redirect_to root_path, notice: "Account deleted. Hope to see you again!"
  end

  private

  def require_login
    return if current_user

    redirect_to sign_in_path, alert: "Please log in to continue."
  end

  def set_user
    @user = User.friendly.find(params[:nickname])
  end

  def authorize_user!
    @user = current_user
    unless @user&.nickname == params[:nickname]
      redirect_to root_path, alert: "Access denied."
    end
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
