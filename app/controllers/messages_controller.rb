class MessagesController < ErrorWrapperController
  include MessagesHelper
  def conversation
    user_id = params[:id]
    my_id = decoded_token[0]['user_id']

    respond_with_serialized_messages_between_users(user_id, my_id)
  end

  def create
    sender_id = decoded_token[0]['user_id']

    create_message_params = { sender_id:, receiver_id: message_params[:receiver_id], message: message_params[:message] }
    pictures = params[:pictures]

    create_message_and_respond(create_message_params, pictures)
  end

  private

  def message_params
    params.permit(:receiver_id, :message)
  end
end
