class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :is_verified, :profile_picture

  def profile_picture
    Cloudinary::Utils.cloudinary_url(object.profile_picture)
  end
end
