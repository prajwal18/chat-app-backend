class MessageSerializer < ActiveModel::Serializer
  attributes :id, :message, :sender, :receiver, :created_at, :is_picture

  def sender
    JSON.parse object.sender.to_json(only: %i[id name]).to_s
  end

  def receiver
    JSON.parse object.receiver.to_json(only: %i[id name]).to_s
  end

  def message
    if object.is_picture
      Cloudinary::Utils.cloudinary_url(object.message)
    else
      object.message
    end
  end
end
