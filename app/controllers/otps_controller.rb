class OtpsController < ErrorWrapperController
  skip_before_action :authorized

  def send_to_mail

    email = send_to_mail_params[:email]
    otp = Otp.generate
    # Some logic to send the otp to the user's email
    user = User.where(email:).first

    otp_entity = save_otp(user.id, otp)
    UserMailer.otp_email(user, otp, otp_entity.expires_at).deliver_later
    render json: {
      message: 'OTP has been sent to your email.'
    }, status: :ok
  end

  def verify_user
    email = verify_params[:email]
    otp = verify_params[:otp]

    user = User.where(email:).first

    if otp_is_verified(user, otp)
      user.is_verified = true
      user.save!
      render json: {
        message: "#{user.name} has been verified successfully."
      }, status: :ok
    else
      render json: {
        message: 'Sorry your otp does not match or it has expired.'
      }, status: 401

    end
  end

  def verify_otp
    email = verify_params[:email]
    otp = verify_params[:otp]

    user = User.where(email:).first

    if otp_is_verified(user, otp)
      render json: {
        message: "The provided otp is valid"
      }, status: :ok
    else
      render json: {
        message: 'Sorry your otp does not match or it has expired.'
      }, status: 401

    end
  end

  private

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

  def verify_params
    params.permit(:email, :otp)
  end

  def send_to_mail_params
    params.permit(:email)
  end
end
