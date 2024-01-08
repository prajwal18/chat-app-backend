module MessagesHelper
  def respond_with_serialized_messages_between_users(user_id, my_id)
    messages = Message.find_messages(user_id, my_id)
    messages.collect!(&:serialize)
    render json: {
      messages:
    }, status: :ok
  end

  def create_message_and_respond(sender_id, message_hash)
    message_hash.merge!(sender_id:)
    if message_hash.key?(:picture)
      create_picture_message_and_respond(message_hash)
    else
      create_text_message_and_respond(message_hash)
    end
  end

  def create_text_message_and_respond(message_hash)
    message = Message.create(message_hash)
    render json: {
      message: message.serialize
    }, status: :created
  end

  def create_picture_message_and_respond(message_hash)
    picture = convert_picture_to_base64(message_hash[:picture])
    message_hash.delete(:picture)
    message_hash[:message] = 'loading...'
    message = Message.create(message_hash)
    UpdateMessageWithPictureJob.perform_later(message.id, picture)
    render json: {
      message: message.serialize
    }, status: :created
  end

  def convert_picture_to_base64(picture)
    {
      content: Base64.strict_encode64(picture.read),
      filename: picture.original_filename,
      content_type: picture.content_type
    }
  end
end
