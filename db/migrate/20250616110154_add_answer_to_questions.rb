class AddAnswerToQuestions < ActiveRecord::Migration[8.0]
  def change
    add_column :questions, :answer, :text
  end
end
