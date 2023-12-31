class UsersController < ErrorWrapperController
  include UsersHelper
  skip_before_action :authorized, only: %i[create]

  def list
    respond_with_all_serialized_users
  end

  def show
    user_id = params[:id]
    respond_with_a_user(user_id)
  end

  def me
    render json: current_user.serialize, status: :ok
  end

  def create
    user = User.create!(user_params)
    token = encode_token(user_id: user.id)
    successful_signup_response(user, token)
  end

  def change_password
    user_id = params[:id]
    user = User.find(user_id)

    if user.authenticate(change_password_params[:old_password])
      change_user_password_and_respond(user, change_password_params[:new_password])
    else
      unsuccessful_password_change_response
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password)
  end

  def change_password_params
    params.permit(:old_password, :new_password)
  end
end
