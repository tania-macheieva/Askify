module QuestionsHelper
  def question_count_text(count)
    "Question".pluralize(count)
  end
end
