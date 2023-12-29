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
      token: token
    }, status: :created
  end

  private

  def user_params
    params.permit(:name, :email, :password)
  end
end
