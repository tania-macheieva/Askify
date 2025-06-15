class Question < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  belongs_to :user
  belongs_to :receiver, class_name: "User"

  validates :body, presence: true

  def slug_candidates
    [
      slug_base,
      [ slug_base, id ]
    ]
  end

  def should_generate_new_friendly_id?
    body_changed? || super
  end

  private

  def slug_base
    base = body.to_s.truncate(50, omission: "").parameterize
    base.present? ? base : "question"
  end
end
