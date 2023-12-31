class AuthController < ErrorWrapperController
  skip_before_action :authorized

  def login
    user = User.find_by!(email: login_params[:email])
    if user.authenticate(login_params[:password])
      token = encode_token(user_id: user.id)
      render json: {
        user: user.serialize,
        token:
      }, status: :accepted
    else
      render json: { message: 'Incorrect password' }, status: :unauthorized
    end
  end

  def forgot_password
    otp = forgot_password_params[:otp]
    email = forgot_password_params[:email]

    user = User.where(email:).first
    otp_entity = Otp.where(user_id: user.id).first
    # Check if the otp is valid if so change the password
    if BCrypt::Password.new(otp_entity.otp) == otp
      new_hashed_password = BCrypt::Password.create(params[:new_password])
      user.password_digest = new_hashed_password
      user.save!
      render json: {
        message: 'OTP is valid and password was changed successfully.'
      }, status: :ok
    else
      render json: {
        message: "Your otp doesn't match or is expired, unable to change password."
      }, status: 401
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
