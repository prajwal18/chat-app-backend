class MessagesController < ErrorWrapperController
  include MessagesHelper
  def conversation
    user_id = params[:id]
    my_id = decoded_token[0]['user_id']

    respond_with_serialized_messages_between_users(user_id, my_id)
  end

  def create
    sender_id = decoded_token[0]['user_id']
    create_message_and_respond(sender_id, message_params)
  end

  private

  def message_params
    params.permit(:receiver_id, :message, :picture)
  end
end
