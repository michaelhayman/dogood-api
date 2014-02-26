FactoryGirl.define do
  factory :follow do
    followable_id  1
    followable_type  "Good"
    follower_id  1
    follower_type "User"
    blocked false
  end
end

