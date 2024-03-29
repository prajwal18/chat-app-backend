class Otp < ApplicationRecord
  before_create :add_expires_at
  validates_presence_of :otp
  belongs_to :user

  def add_expires_at
    # NOTE: Date + n will increment date with n days
    # 1 day has 1440 minutes.
    # Rational is used to create a fraction without lossing accuracy to floating points rounding.
    # The below expression is used to create a date that is 5 minutes ahead of whenever the statement is executed.
    self.expires_at = DateTime.now + Rational(5, 1440) # Otp expires after 5 minute
  end

  def self.generate
    rand(100_000..999_999).to_s
  end

  def self.encrypt(otp)
    BCrypt::Password.create(otp)
  end
end
