FactoryGirl.define do
  factory :category do
    name "Environment"

    trait :health do
      name "Health"
    end

    trait :care do
      name "Care"
    end
  end
end

