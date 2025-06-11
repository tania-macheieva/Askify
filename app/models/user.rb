class User < ApplicationRecord
  has_secure_password
  has_one_attached :avatar
  has_many :questions
  has_many :received_questions, class_name: "Question", foreign_key: :receiver_id

  before_save :downcase_nickname

  validates :email, presence: true, uniqueness: true
  validates :github_url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true }
  validates :linkedin_url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true }

  def downcase_nickname
    nickname.downcase!
  end
end
