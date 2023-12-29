class User < ApplicationRecord
  CONFIRMATION_TOKEN_EXPIRATION = 10.minutes
  has_secure_password
  before_save :downcase_email
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, presence: true, uniqueness: true

  def confirm!
    update_columns(confirmed_at: Time.current)
  end

  def serialize
    UserSerializer.new(self)
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id', dependent: :destroy
  has_many :received_messages, class_name: 'Message', foreign_key: 'receiver_id', dependent: :destroy
  has_one :otp
end
