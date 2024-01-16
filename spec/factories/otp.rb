FactoryBot.define do
  factory :otp, class: Otp do
    otp { '123456' }
    association :user, factory: :user
  end
end
