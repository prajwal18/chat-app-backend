class Message < ApplicationRecord

  def self.find_messages(user_one, user_two)
    users = [user_one, user_two]
    Message.where(sender: users, receiver: users).order(created_at: :asc).to_a
  end

  def serialize
    MessageSerializer.new(self)
  end

  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id'
end
