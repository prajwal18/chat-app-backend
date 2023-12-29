class MessagesController < ErrorWrapperController
  def conversation
    user_id = params[:id]
    my_id = decoded_token[0]['user_id']
    messages = Message.find_messages(user_id, my_id)
    messages.collect!(&:serialize)
    render json: {
      messages: messages
    }, status: :ok
  end

  def create
    sender_id = decoded_token[0]['user_id']
    permitted_params = message_params
    permitted_params[:sender_id] = sender_id
    message = Message.create(permitted_params)
    render json: {
      message: message.serialize
    }, status: :created
  end

  private

  def message_params
    params.permit(:receiver_id, :message)
  end
end
