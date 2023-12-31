class UsersController < ErrorWrapperController
  skip_before_action :authorized, only: %i[create show list]

  def list
    users = User.all
    serialized_users = users.to_a
    serialized_users.collect!(&:serialize)
    render json: {
      users: serialized_users
    }, status: :ok
  end

  def show
    user_id = params[:id]
    user = User.find(user_id)
    render json: {
      user: user.serialize
    }, status: :ok
  end

  def me
    render json: current_user, status: :ok
  end

  def create
    user = User.create!(user_params)
    token = encode_token(user_id: user.id)
    render json: {
      user: user.serialize,
      token:
    }, status: :created
  end

  def change_password  
    user_id = params[:id]
    user = User.find(user_id)

    if check_password(user.password_digest, params[:old_password])
      new_hashed_password = BCrypt::Password.create(params[:new_password])
      user.password_digest = new_hashed_password
      user.save!
      render json: {
        message: 'Your password has been changed successfully.'
      }, status: :ok
    else
      render json: {
        message: 'Your old password does not match. Unable to change password'
      }, status: 401
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password)
  end

  def change_password_params
    params.permit(:old_password, :new_password)
  end

  def check_password(hashed_password, old_password)
    BCrypt::Password.new(hashed_password) == old_password
  end
end
