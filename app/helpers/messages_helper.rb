module MessagesHelper
  def respond_with_serialized_messages_between_users(user_id, my_id)
    messages = Message.find_messages(user_id, my_id)
    messages.collect!(&:serialize)
    render json: {
      messages:
    }, status: :ok
  end

  def create_message_and_respond(message_hash, pictures)
    if pictures
      create_picture_messages_and_respond(message_hash, pictures)
    else
      create_text_message_and_respond(message_hash)
    end
  end

  def create_text_message_and_respond(message_hash)
    message = Message.create!(message_hash)
    render json: {
      message: message.serialize
    }, status: :created
  end

  def create_picture_messages_and_respond(message_hash, pictures)
    messages = create_picture_messages(message_hash, pictures)

    render json: {
      messages:,
      bulk: true
    }, status: :created
  end

  def create_picture_messages(message_hash, pictures)
    messages = []

    pictures.each do |picture|
      picture64 = convert_picture_to_base64(picture)
      message_hash[:message] = 'loading...'
      message = Message.create!(message_hash)
      UpdateMessageWithPictureJob.perform_later(message.id, picture64)
      messages << message.serialize
    end
    messages
  end

  def convert_picture_to_base64(picture)
    {
      content: Base64.strict_encode64(picture.read),
      filename: picture.original_filename,
      content_type: picture.content_type
    }
  end
end
