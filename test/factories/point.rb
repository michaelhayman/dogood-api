FactoryGirl.define do
  factory :point do
    to_user_id 5
    pointable_id 5
    pointable_type "Good"
    pointable_sub_type "Post"
    points 5000
  end
end

