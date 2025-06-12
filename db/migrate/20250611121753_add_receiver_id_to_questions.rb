class AddReceiverIdToQuestions < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :receiver_id, :integer
  end
end
