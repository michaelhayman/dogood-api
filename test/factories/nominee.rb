FactoryGirl.define do
  factory :nominee do
    full_name "Michael Hayman"
    email Faker::Internet.email
    invite true

    trait :dg_user do
      user
    end

    trait :not_invitable do
      invite false
    end
  end
end

