class QuestionsController < ApplicationController
  before_action :set_question, only: [ :update, :destroy, :edit ]
  before_action :check_question_owner, only: [ :edit, :update, :destroy ]

  def create
    @question = Question.new(question_params)
    @question.user = current_user

    if @question.save
      redirect_to user_path(@question.receiver), notice: "Your question was sent successfully!"
    else
      @user = User.find(params[:question][:receiver_id])
      @questions = @user.questions.order(created_at: :desc)
      @received_questions = @user.received_questions.order(created_at: :desc)
      @new_question = @question

      flash.now[:alert] = "Please fill in the question field"
      render "users/show"
    end
  end

  def destroy
    receiver = @question.receiver
    @question.destroy
    redirect_back fallback_location: user_path(receiver), notice: "Your question deleted successfully!"
  end

  def index
    @question = Question.new
    @questions = Question.all
    @user = current_user
  end

  def new
    @question = Question.new
    @receiver = User.find(params[:receiver_id]) if params[:receiver_id]
  end

  def edit
    @receiver = @question.receiver
    @sender = @question.user
    session[:return_to] = request.referer if request.referer
  end

  def update
    if @question.update(question_params)
      redirect_to session.delete(:return_to) || user_path(@question.receiver), notice: "Your question edited successfully!"
    else
      flash.now[:alert] = "The field is empty"
      render :edit
    end
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def check_question_owner
    unless @question.user == current_user
      redirect_back fallback_location: root_path, alert: "You can only edit your own questions."
    end
  end

  def question_params
    params.require(:question).permit(:body, :receiver_id)
  end
end
