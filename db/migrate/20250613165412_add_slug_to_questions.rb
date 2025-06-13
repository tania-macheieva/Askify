class AddSlugToQuestions < ActiveRecord::Migration[8.0]
  def change
    add_column :questions, :slug, :string
    add_index :questions, :slug
  end
end
