FactoryBot.define do
  factory :message, class: Message do
    message { 'Bobo the clown.' }
    association :sender, factory: :user
    association :receiver, factory: :user
  end
end
