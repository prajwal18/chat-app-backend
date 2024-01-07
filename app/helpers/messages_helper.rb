module MessagesHelper
  def respond_with_serialized_messages_between_users(user_id, my_id)
    messages = Message.find_messages(user_id, my_id)
    messages.collect!(&:serialize)
    render json: {
      messages:
    }, status: :ok
  end

  def create_message_and_respond(sender_id, message_hash)
    message_properties = { sender_id:, receiver_id: message_hash[:receiver_id] }

    if message_hash.key?(:picture)
      image = Cloudinary::Uploader.upload(message_hash[:picture])
      message_properties.merge!(message: image['public_id'])
      message_properties.merge!(is_picture: true)
    else
      message_properties.merge!(message: message_hash[:message])
    end
    message = Message.create(message_properties)
    render json: {
      message: message.serialize
    }, status: :created
  end
end
