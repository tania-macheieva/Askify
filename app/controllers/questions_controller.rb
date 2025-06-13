class QuestionsController < ApplicationController
  before_action :set_question, only: %i[edit update destroy]
  before_action :check_question_owner, only: %i[edit update destroy]

  def index
    @user = current_user
    @question = Question.new
    @questions = Question.all
  end

  def new
    @question = Question.new
    @receiver = User.friendly.find(params[:receiver_id]) if params[:receiver_id]
  end

  def create
    @question = current_user.questions.build(question_params)

    if @question.save
      redirect_to user_path(@question.receiver), notice: "Your question was sent successfully!"
    else
      load_user_questions_data
      flash.now[:alert] = "Please fill in the question field"
      render "users/show"
    end
  end

  def edit
    @receiver = @question.receiver
    @sender = @question.user
    session[:return_to] ||= request.referer
  end

  def update
    if @question.update(question_params)
      redirect_to session.delete(:return_to) || user_path(@question.receiver), notice: "Your question edited successfully!"
    else
      flash.now[:alert] = "The field is empty"
      render :edit
    end
  end

  def destroy
    receiver = @question.receiver
    @question.destroy
    redirect_back fallback_location: user_path(receiver), notice: "Your question deleted successfully!"
  end

  private

  def set_question
    @question = Question.friendly.find(params[:id])
  end

  def check_question_owner
    return if @question.user == current_user

    redirect_back fallback_location: root_path, alert: "You can only edit your own questions."
  end

  def question_params
    params.require(:question).permit(:body, :receiver_id)
  end

  def load_user_questions_data
    @user = User.friendly.find(params[:question][:receiver_id])
    @questions = @user.questions.order(created_at: :desc)
    @received_questions = @user.received_questions.order(created_at: :desc)
    @new_question = @question
  end
end
