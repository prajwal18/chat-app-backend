class OtpsController < ErrorWrapperController
  include OtpsHelper
  skip_before_action :authorized

  def send_to_mail
    email = send_to_mail_params[:email]
    otp_code = Otp.generate
    user = UsersHelper.find_user_from_email(email)

    send_otp_to_email_and_respond_with_json(user, otp_code)
  end

  def verify_user
    email = verify_params[:email]
    otp = verify_params[:otp]

    user = UsersHelper.find_user_from_email(email)

    if otp_is_verified(user, otp)
      verify_user_and_respond(user)
    else
      invalid_otp_response
    end
  end

  def verify_otp
    email = verify_params[:email]
    otp = verify_params[:otp]

    user = UsersHelper.find_user_from_email(email)

    if otp_is_verified(user, otp)
      otp_match_response
    else
      invalid_otp_response
    end
  end

  private

  def verify_params
    params.permit(:email, :otp)
  end

  def send_to_mail_params
    params.permit(:email)
  end
end
