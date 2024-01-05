module AuthHelper
  def successful_login_response(user, token)
    render json: {
      user: user.serialize,
      token:
    }, status: :accepted
  end

  def unsuccessful_login_response
    render json: { message: 'Incorrect password or username' }, status: :unauthorized
  end

  def unsuccessful_password_change_response
    render json: {
      message: "Your otp doesn't match or is expired, unable to change password."
    }, status: 401
  end

  def change_password_and_respond(user, new_password)
    new_hashed_password = BCrypt::Password.create(new_password)
    user.password_digest = new_hashed_password
    user.save!
    render json: {
      message: 'OTP is valid and password changed successfully.'
    }, status: :ok
  end

  class Helper
    extend AuthHelper
  end
end
