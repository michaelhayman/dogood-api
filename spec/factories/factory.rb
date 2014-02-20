FactoryGirl.define do
  factory :good do
    caption "Look at the good that I did!"
    user_id 5
    category
    # nominee FactoryGirl.create(:nominee)
    nominee
    evidence "http://www.images.amazon.com/dev/null"
    lat 43.652527
    lng -79.381961

    trait :no_user do
      user_id ""
    end

    trait :sydney do
      lat -33.867387
      lng 151.207629
    end

    trait :long_caption do
      caption "Look at all the fun things I can type I can type so fast you won't even know I'm here do you think this is going on too long I'm pretty sure it is. This is even longer just to be sure that it's not valid."
    end
  end

  factory :nominee do
    full_name "Michael Hayman"
    email Faker::Internet.email
    # good FactoryGirl.build(:good)
    # user FactoryGirl.build(:user)
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

  factory :follow do
    followable_id  1
    followable_type  "Good"
    follower_id  1
    follower_type "User"
    blocked false
  end

  factory :entity do
    link "dogood://users/2"
    link_id 2
    link_type "user"
    title "Coyote"
    entityable_id 112
    entityable_type "Comment"
    range ["0", "7"]
  end

  factory :report do
    reportable_type "good"
    reportable_id 41
    user_id 1
  end

  factory :comment do
    comment "Comment"
    commentable_id 1
    commentable_type "Good"
    user_id 1

    trait :too_short do
      comment "Look"
    end

    trait :too_long do
      comment "Look at all the fun things I can type I can type so fast you won't even know I'm here do you think this is going on too long I'm pretty sure it is. This is even longer just to be sure that it's not valid."
    end
  end

end

