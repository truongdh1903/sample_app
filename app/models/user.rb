class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.email_regex
  before_save :downcase_email
  validates :name, presence: true
  validates :email, presence: true, length: {maximum: Settings.email_max_len},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: true
  validates :password, presence: true,
    length: {minimum: Settings.passwd_min_len}
  has_secure_password

  def downcase_email
    email.downcase!
  end

  def self.digest string
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create string, cost: cost
  end
end
