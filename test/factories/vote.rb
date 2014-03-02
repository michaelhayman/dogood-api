FactoryGirl.define do
  factory :vote do
    votable_id 5

    trait :good_like do
      votable_type "Good"
    end
  end
end

