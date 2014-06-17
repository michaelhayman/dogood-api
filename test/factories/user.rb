FactoryGirl.define do
  factory :user do
    full_name "Michael Hayman"
    email { Faker::Internet.email }
    password "captcha24"
    phone "416-315-7605"
    # level 5

    trait :bob do
      full_name "Bob"
      email { Faker::Internet.email }
      password "snaily53"
      twitter_id "evan"
      facebook_id "marcus"
    end

    trait :tony do
      full_name "Tony"
      email { Faker::Internet.email }
      password "georgeyporge"
      twitter_id "jack"
      facebook_id "matt"
    end
  end
end

