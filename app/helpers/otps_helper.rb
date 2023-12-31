module OtpsHelper
  def save_otp(user_id, otp)
    if user_has_otp(user_id)
      hashed_otp = BCrypt::Password.create(otp)
      otp_entity = Otp.where(user_id:).first
      otp_entity.otp = hashed_otp
      otp_entity.save!
      otp_entity
    else
      Otp.create!(otp:, user_id:)
    end
  end

  def otp_is_verified(user, otp)
    users_otp = Otp.where(user_id: user.id).first
    BCrypt::Password.new(users_otp.otp) == otp
  end

  def user_has_otp(user_id)
    Otp.where(user_id:).exists?
  end
end
