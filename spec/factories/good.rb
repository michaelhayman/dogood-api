FactoryGirl.define do
  factory :good do
    user { FactoryGirl.create(:user, :tony) }
    caption "Look at the good that I did!"
    category
    nominee
    evidence "http://www.images.amazon.com/dev/null"
    lat 43.652527
    lng -79.381961

    trait :no_user do
      user nil
    end

    trait :bob do
      user { FactoryGirl.create(:user, :bob) }
    end

    trait :sydney do
      lat -33.867387
      lng 151.207629
    end

    trait :long_caption do
      caption "Look at all the fun things I can type I can type so fast you won't even know I'm here do you think this is going on too long I'm pretty sure it is. This is even longer just to be sure that it's not valid."
    end
  end
end

