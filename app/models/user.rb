class User < ApplicationRecord
  extend FriendlyId
  friendly_id :nickname, use: :slugged

  has_secure_password

  has_one_attached :avatar

  has_many :questions
  has_many :received_questions, class_name: "Question", foreign_key: :receiver_id

  before_save :downcase_nickname

  validates :email, :nickname, :name, :position, presence: true
  validates :password, presence: true, on: :create

  validates :email, uniqueness: true

  URL_FORMAT = /\Ahttps?:\/\/.+\z/

  validates :github_url, :linkedin_url, format: {
    with: URL_FORMAT,
    message: "must be a valid HTTP or HTTPS URL"
  }, allow_blank: true

  validate :validate_github_url, if: -> { github_url.present? }
  validate :validate_linkedin_url, if: -> { linkedin_url.present? }

  def should_generate_new_friendly_id?
    nickname_changed? || super
  end

  private

  def validate_url(url, attribute, expected_domain)
    uri = URI.parse(url)
    unless uri.host&.downcase&.include?(expected_domain)
      errors.add(attribute, "must be a #{expected_domain.capitalize} URL")
    end
  rescue URI::InvalidURIError
    errors.add(attribute, "must be a valid URL")
  end

  def downcase_nickname
    nickname&.downcase!
  end

  def validate_github_url
    validate_url(github_url, :github_url, "github.com")
  end

  def validate_linkedin_url
    validate_url(linkedin_url, :linkedin_url, "linkedin.com")
  end
end
