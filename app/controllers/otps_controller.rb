class OtpsController < ErrorWrapperController
  skip_before_action :authorized

  def send_to_mail
    email = send_to_mail_params[:email]
    otp = Otp.generate
    # Some logic to send the otp to the user's email
  end

  def verify
    email = verify_params[:email]
    otp = verify_params[:otp]
    
  end

  private

  def save_otp(user_id, otp)
    hashed_otp = Otp.encrypt(otp)
    if user_has_otp(user_id)
      Otp.where(user_id:).first.update(otp: hashed_otp)
    else
      Otp.create!(otp: hashed_otp, user_id:)
    end
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
