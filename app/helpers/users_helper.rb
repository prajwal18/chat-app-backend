module UsersHelper
  def find_user_from_email(email)
    user = User.where(email:).first
    return user unless user.nil?

    raise ActiveRecord::RecordNotFound
  end

  def respond_with_all_serialized_users(query)
    query = query.nil? ? '' : query
    users = User.where('name LIKE :query', query: "%#{query}%")
    serialized_users = users.to_a
    serialized_users.collect!(&:serialize)
    render json: {
      users: serialized_users
    }, status: :ok
  end

  def respond_with_a_user(id)
    user = User.find(id:)

    return if user.nil?

    render json: {
      user: user.serialize
    }, status: :ok
  end

  def create_user(user_params)
    binding.pry

    if user_params.key?(:profile_picture)
      image = Cloudinary::Uploader.upload(user_params[:profile_picture])
      picture_id = image['public_id']
      user_params[:profile_picture] = picture_id
    end
    User.create(user_params)
  end

  def successful_signup_response(user, token)
    render json: {
      user: user.serialize,
      token:
    }, status: :created
  end

  def successful_update_response(user, token)
    render json: {
      user: user.serialize,
      token:
    }, status: :ok
  end

  def update_user(user_id, update_hash)
    user = User.find(user_id)

    token = ApplicationHelper::Helper.encode_token(user_id:)
    if update_hash.key?('profile_picture')
      # Note we'll only store the asset_id and fetch the url in serializer
      picture_id = updated_profile_picture(user, update_hash[:profile_picture])
      user.profile_picture = picture_id
    else
      user.update(update_hash)
    end
    user.save
    successful_update_response(user, token)
  end

  def updated_profile_picture(user, new_pic)
    Cloudinary::Uploader.destroy(user.profile_picture) unless user.profile_picture.nil?
    image = Cloudinary::Uploader.upload(new_pic)
    image['public_id']
  end

  def change_user_password_and_respond(user, new_password)
    new_hashed_password = BCrypt::Password.create(new_password)
    user.password_digest = new_hashed_password
    user.save
    render json: {
      message: 'Your password has been changed successfully.'
    }, status: :ok
  end

  def unsuccessful_password_change_response
    render json: {
      message: 'Your old password does not match. Unable to change password'
    }, status: 401
  end

  class Helper
    extend UsersHelper
  end
end
