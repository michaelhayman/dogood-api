FactoryGirl.define do
  factory :user do
    full_name "Michael Hayman"
    email { Faker::Internet.email }
    password "captcha24"

    trait :bob do
      full_name "Bob"
      email { Faker::Internet.email }
      password "snaily53"
    end

    trait :tony do
      full_name "Tony"
      email { Faker::Internet.email }
      password "georgeyporge"
    end
  end
end

