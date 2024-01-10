class User < ApplicationRecord
  has_secure_password
  before_save :downcase_email
  after_create :send_otp
  validates_presence_of :name
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, presence: true, uniqueness: true

  def serialize
    UserSerializer.new(self)
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  def send_otp
    otp = Otp.generate

    # Save user's otp in db
    otp_enity = Otp.create(otp:, user_id: id)

    # Send welcome message and otp to the user
    UserMailer.welcome_email(self).deliver_later
    UserMailer.otp_email(self, otp, otp_enity.expires_at).deliver_later
  end

  has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id', dependent: :destroy
  has_many :received_messages, class_name: 'Message', foreign_key: 'receiver_id', dependent: :destroy
  has_one :otp
end
