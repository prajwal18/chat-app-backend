module MessagesHelper
  def respond_with_serialized_messages_between_users(user_id, my_id)
    messages = Message.find_messages(user_id, my_id)
    messages.collect!(&:serialize)
    render json: {
      messages:
    }, status: :ok
  end

  def create_message_and_respond(sender_id, receiver_id, message)
    message = Message.create(sender_id:, receiver_id:, message:)
    render json: {
      message: message.serialize
    }, status: :created
  end
end
