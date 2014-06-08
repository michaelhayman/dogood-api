FactoryGirl.define do
  factory :good do
    user { FactoryGirl.create(:user, :tony) }
    caption "Look at the good that I did!"
    category
    nominee
    evidence "http://www.images.amazon.com/dev/null"
    lat 43.652527
    lng -79.381961
    done false

    trait :done do
      done true
      nominee { FactoryGirl.create(:nominee, :dg_user) }
    end

    trait :no_user do
      user nil
    end

    trait :no_nominee do
      nominee nil
    end

    trait :lame do
      caption "Big oil"
      cached_votes_up 0
      cached_followers_count 0
      cached_comments_count 0
    end

    trait :average do
      caption "Took out the trash"
      cached_votes_up 10
      cached_followers_count 25
      cached_comments_count 25
    end

    trait :popular do
      caption "Freed a nation"
      cached_votes_up 25
      cached_followers_count 50
      cached_comments_count 50
    end

    trait :health do
      category { FactoryGirl.create(:category, :health) }
    end

    trait :bob do
      user { FactoryGirl.create(:user, :bob) }
    end

    trait :tagged do
      after(:create) do |good|
        good.entities = [ FactoryGirl.create(:entity, :awesome, entityable: good)  ]
      end
    end

    trait :sydney do
      lat -33.867387
      lng 151.207629
    end

    trait :long_caption do
      caption "Look at all the fun things I can type I can type so fast you won't even know I'm here do you think this is going on too long I'm pretty sure it is. This is even longer just to be sure that it's not valid. This is a really long post you have to trust that it is because I say that it is isn't it obvious that this post is way too long?  I will type even more words just to ensure that it is long enough for you to conquer and you can see that it is really long can't you?  I can.  It will be, trust me, this is long."
    end
  end
end

