class Question < ApplicationRecord
  belongs_to :user
  belongs_to :receiver, class_name: "User"

  validates :body, presence: true
end
