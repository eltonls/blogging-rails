class User < ApplicationRecord
  before_create :generate_confirmation_token
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :posts, dependent: :destroy
  attribute :password_reset_token, :string

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def confirm!
    update_columns(confirmed_at: Time.current, confirmation_token: nil)
  end

  def confirmed?
    confirmed_at.present?
  end

  def generate_confirmation_token
    self.confirmation_token = SecureRandom.urlsafe_base64
    self.confirmation_sent_at = Time.current
  end

  def generate_password_reset_token
    @raw_reset_token = SecureRandom.urlsafe_base64
    puts "Generated raw token: #{@raw_reset_token}"

    update_columns(
      password_reset_token: @raw_reset_token,
      password_reset_sent_at: Time.current
    )

    puts "Stored token in DB: #{User.find(id).password_reset_token}"
    puts "Current instance token: #{password_reset_token}"

    @raw_reset_token
  end

  def password_reset_expired?
    self.password_reset_sent_at < 2.hours.ago
  end
end
