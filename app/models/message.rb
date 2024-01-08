class Message < ApplicationRecord
  after_create_commit :broadcast

  after_update :broadcast_update

  def self.find_messages(user_one, user_two)
    users = [user_one, user_two]
    Message.where(sender: users, receiver: users).order(created_at: :asc).to_a
  end

  def serialize
    MessageSerializer.new(self)
  end

  def broadcast
    ActionCable.server.broadcast(receiver_id, { message: serialize })
  end

  def broadcast_update
    ActionCable.server.broadcast(receiver_id, { message: serialize, update: true })
    ActionCable.server.broadcast(sender_id, { message: serialize, update: true })
  end

  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id'
end
