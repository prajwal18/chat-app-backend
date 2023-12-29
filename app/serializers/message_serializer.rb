class MessageSerializer < ActiveModel::Serializer
  attributes :id, :message
  belongs_to :sender
  belongs_to :receiver
end
