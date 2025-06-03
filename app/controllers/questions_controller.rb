class QuestionsController < ApplicationController
  def create
    question_params = params.require(:question).permit(:body, :user_id)
    question = Question.create(question_params)

    redirect_to question_path(question), notice: "Your question created successfully!"
  end

  def update
    @question = Question.find(params[:id])
    @question.update(
      body: params[:question][:body],
      user_id: params[:question][:user_id]
    )

    redirect_to question_path(@question), notice: "Your question edited successfully!"
  end

  def destroy
    @question = Question.destroy(params[:id])
    @question.destroy

    redirect_to questions_path
  end

  def show
    @question = Question.find(params[:id])
  end

  def index
      @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def edit
    @question = Question.find(params[:id])
  end
end
