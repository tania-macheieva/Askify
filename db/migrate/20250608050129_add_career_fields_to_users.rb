class AddCareerFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :education, :text
    add_column :users, :experience, :text
    add_column :users, :tech_stack, :text
    add_column :users, :languages, :text
  end
end
