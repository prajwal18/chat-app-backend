FactoryBot.define do
  factory :message, class: Message do
    message { 'Bozo the clown.' }
    association :sender, factory: :user
    association :receiver, factory: :user
  end
end
