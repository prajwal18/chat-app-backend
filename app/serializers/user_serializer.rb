class UserSerializer < ActiveModel::Serializer
    attributes :id, :name, :email, :is_verified, :profile_picture
end