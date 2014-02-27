FactoryGirl.define do
  factory :comment do
    comment "Comment"
    commentable_id 1
    user_id 1
    commentable_type "Good"

    trait :for_good do
      commentable_type "Good"
    end

    trait :too_short do
      comment "Look"
    end

    trait :too_long do
      comment "Look at all the fun things I can type I can type so fast you won't even know I'm here do you think this is going on too long I'm pretty sure it is. This is even longer just to be sure that it's not valid."
    end
  end
end

