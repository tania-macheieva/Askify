class QuestionsController < ApplicationController
  before_action :set_question, only: %i[edit update destroy answer remove_answer]
  before_action :check_question_owner, only: %i[edit update destroy]
  before_action :check_question_receiver, only: %i[answer remove_answer]

  def index
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
      load_user_questions_data(@question.receiver)
      flash.now[:alert] = "Please fill in the question field"
      render "users/show"
    end
  end

  def edit
    @receiver = @question.receiver
    @sender = @question.user
    session[:return_to] = request.referer if request.referer.present?
  end

  def update
    if @question.update(question_params)
      redirect_to session.delete(:return_to) || user_path(@question.receiver),
                  notice: "Your question edited successfully!"
    else
      flash.now[:alert] = "The field is empty"
      render :edit
    end
  end

  def destroy
    receiver = @question.receiver
    @question.destroy
    redirect_back fallback_location: user_path(receiver),
                  notice: "Your question deleted successfully!"
  end

  def answer
    if @question.update(answer_params)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "question-#{@question.id}",
            partial: "questions/question",
            locals: { question: @question }
          )
        end
        format.html do
          redirect_to user_path(@question.receiver, anchor: "question-#{@question.id}"),
                      notice: "Answer saved!"
        end
      end
    else
      flash[:alert] = "Answer can't be blank."
      redirect_to user_path(@question.receiver, anchor: "questions-list")
    end
  end

  def remove_answer
    @question.update(answer: nil)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "question-#{@question.id}",
          partial: "questions/question",
          locals: { question: @question }
        )
      end
      format.html do
        redirect_to user_path(@question.receiver, anchor: "question-#{@question.id}"),
                    notice: "Answer deleted!"
      end
    end
  end

  private

  def set_question
    @question = Question.friendly.find(params[:id])
    redirect_to root_path, alert: "Question not found." unless @question
  end

  def check_question_owner
    return if @question.user == current_user

    redirect_back fallback_location: root_path,
                  alert: "You can only edit your own questions."
  end

  def check_question_receiver
    return if @question.receiver == current_user

    redirect_to root_path, alert: "You can't perform this action."
  end

  def question_params
    params.require(:question).permit(:body, :receiver_id)
  end

  def answer_params
    params.require(:question).permit(:answer)
  end

  def load_user_questions_data(user)
    @user = user
    @questions = @user.questions.order(created_at: :desc)
    @received_questions = @user.received_questions.order(created_at: :desc)
    @new_question = @question
  end
end
