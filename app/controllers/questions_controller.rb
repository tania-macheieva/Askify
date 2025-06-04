class QuestionsController < ApplicationController
  before_action :set_question, only: [ :update, :destroy, :show, :edit ]

def create
  @question = Question.new(question_params)

  if @question.save
    redirect_to question_path(@question), notice: "Your question created successfully!"
  else
    flash.now[:alert] = "The field is empty"
    render :new
  end
end

def update
  @question = Question.find(params[:id])

  if @question.update(question_params)
    redirect_to question_path(@question), notice: "Your question edited successfully!"
  else
    flash.now[:alert] = "The field is empty"
    render :edit
  end
end

  def destroy
    @question.destroy

    redirect_to questions_path, notice: "Your question deleted successfully!"
  end

  def show
  end

  def index
    @question = Question.new
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def edit
  end

  private

  def set_question
     @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:body, :user_id)
  end
end
