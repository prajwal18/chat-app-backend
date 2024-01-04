class ChatsChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    stream_from params[:receiver_id]
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_all_streams
  end
end
