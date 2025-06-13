class Question < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  belongs_to :user
  belongs_to :receiver, class_name: "User"

  validates :body, presence: true

  def slug_candidates
    [
      :truncated_body,
      [ :truncated_body, :id ]
    ]
  end

  def should_generate_new_friendly_id?
    body_changed? || super
  end

  private

  def truncated_body
    body.truncate(50, omission: "").parameterize
  end
end
