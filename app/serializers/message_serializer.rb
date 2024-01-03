class MessageSerializer < ActiveModel::Serializer
  attributes :id, :message, :sender, :receiver

  def sender
    JSON.parse object.sender.to_json(only: %i[id name]).to_s
  end

  def receiver
    JSON.parse object.receiver.to_json(only: %i[id name]).to_s
  end
end
