class AuthController < ErrorWrapperController
  include AuthHelper
  skip_before_action :authorized

  def login
    user = UsersHelper::Helper.find_user_from_email(login_params[:email])
    if user.authenticate(login_params[:password])
      token = encode_token(user_id: user.id)
      successful_login_response(user, token)
    else
      unsuccessful_login_response
    end
  end

  def forgot_password
    otp = forgot_password_params[:otp]
    email = forgot_password_params[:email]
    new_password = forgot_password_params[:new_password]

    user = UsersHelper::Helper.find_user_from_email(email)

    if OtpsHelper::Helper.otp_valid?(user, otp)
      change_password_and_respond(user, new_password)
    else
      unsuccessful_password_change_response
    end
  end

  private

  def login_params
    params.permit(:email, :password)
  end

  def forgot_password_params
    params.permit(:email, :otp, :new_password)
  end
end
