class User < ApplicationRecord
  extend FriendlyId
  friendly_id :nickname, use: :slugged

  has_secure_password
  has_one_attached :avatar
  has_many :questions
  has_many :received_questions, class_name: "Question", foreign_key: :receiver_id

  before_save :downcase_nickname

  validates :email, presence: true, uniqueness: true
  validates :nickname, presence: true
  validates :name, presence: true
  validates :password, presence: true, on: :create
  validates :position, presence: true

  validates :github_url, :linkedin_url, format: {
    with: /\Ahttps?:\/\/.+\z/,
    message: "must be a valid HTTP or HTTPS URL"
  }, allow_blank: true

  validate :validate_github_url, if: -> { github_url.present? }
  validate :validate_linkedin_url, if: -> { linkedin_url.present? }

  def downcase_nickname
    nickname.downcase!
  end

  def should_generate_new_friendly_id?
    nickname_changed? || super
  end

  private

  def validate_github_url
    uri = URI.parse(github_url)
    unless uri.host&.downcase&.end_with?("github.com")
      errors.add(:github_url, "must be a GitHub URL")
    end
  rescue URI::InvalidURIError
    errors.add(:github_url, "must be a valid URL")
  end

  def validate_linkedin_url
    uri = URI.parse(linkedin_url)
    unless uri.host&.downcase&.include?("linkedin.com")
      errors.add(:linkedin_url, "must be a LinkedIn URL")
    end
  rescue URI::InvalidURIError
    errors.add(:linkedin_url, "must be a valid URL")
  end
end
