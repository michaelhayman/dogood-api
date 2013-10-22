# require 'faker'

FactoryGirl.define do

  factory :good do
    caption "Look at the good that I did!"
    user_id 5
    category
    evidence "http://www.images.amazon.com/dev/null"

    trait :no_user do
      user_id ""
    end

    trait :long_caption do
      caption "Look at all the fun things I can type I can type so fast you won't even know I'm here do you think this is going on too long I'm pretty sure it is. This is even longer just to be sure that it's not valid."
    end
  end

  factory :category do
    name "Environment"
  end

  factory :user do
    full_name "Michael Hayman"
    email Faker::Internet.email
    password "captcha24"
  end

  factory :reward do
    cost 5000
    title "Air Canada Flight"
    subtitle "To Vegas"
    quantity 50
    quantity_remaining 10
  end

  factory :point do
    to_user_id 5
    pointable_id 5
    pointable_type "Good"
    pointable_sub_type "Post"
    points 5000
  end

  factory :claimed_reward do
    reward
    user
  end

end

