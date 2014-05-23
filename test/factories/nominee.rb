FactoryGirl.define do
  factory :nominee do
    full_name "Michael Hayman"
    email Faker::Internet.email

    trait :dg_user do
      user
    end
  end
end

