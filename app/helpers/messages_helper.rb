module MessagesHelper
  def respond_with_serialized_messages_between_users(user_id, my_id)
    messages = Message.find_messages(user_id, my_id)
    messages.collect!(&:serialize)
    render json: {
      messages:
    }, status: :ok
  end

  def create_message_and_respond(sender_id, message_hash)
    if message_hash.key?(:picture)
      msg_hash = { sender_id:, receiver_id: message_hash[:receiver_id], is_picture: true }
      create_picture_message(msg_hash, message_hash[:picture])
    else
      message_hash.merge!(sender_id:)
      create_text_message_and_respond(message_hash)
    end
  end

  def create_text_message_and_respond(message_hash)
    message = Message.create(message_hash)
    render json: {
      message: message.serialize
    }, status: :created
  end

  def create_picture_message(message_hash, picture)
    image = Cloudinary::Uploader.upload(picture)
    message_hash.merge!(message: image['public_id'])
    message = Message.create(message_hash)
    message.serialize
    render json: {
      message: message.serialize
    }, status: :created
  end
end
