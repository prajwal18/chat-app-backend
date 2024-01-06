module OtpsHelper
  def save_otp(user_id, otp)
    if user_has_otp(user_id)
      hashed_otp = BCrypt::Password.create(otp)
      otp_entity = Otp.where(user_id:).first
      otp_entity.otp = hashed_otp
      otp_entity.save
      otp_entity
    else
      Otp.create(otp:, user_id:)
    end
  end

  def otp_valid?(user, otp)
    users_otp = Otp.where(user_id: user.id).first
    BCrypt::Password.new(users_otp.otp) == otp && users_otp.expires_at >= DateTime.now
  end

  def user_has_otp(user_id)
    Otp.where(user_id:).exists?
  end

  def send_otp_to_email_and_respond(user, otp_code)
    otp_entity = save_otp(user.id, otp_code)
    UserMailer.otp_email(user, otp_code, otp_entity.expires_at).deliver_later
    render json: {
      message: 'OTP has been sent to your email.'
    }, status: :ok
  end

  def verify_user_and_respond(user)
    user.is_verified = true
    user.save
    render json: {
      message: "#{user.name} has been verified successfully."
    }, status: :ok
  end

  def otp_match_response
    render json: {
      message: 'The provided otp is valid'
    }, status: :ok
  end

  def invalid_otp_response
    render json: {
      message: 'Sorry your otp does not match or it has expired.'
    }, status: 401
  end

  class Helper
    extend OtpsHelper
  end
end
