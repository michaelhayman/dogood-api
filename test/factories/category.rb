FactoryGirl.define do
  factory :category do
    name "Environment"
    colour "c4c622"

    trait :health do
      name "Health"
      colour "d52a25"
    end

    trait :care do
      name "Care"
      colour "b33977"
    end
  end
end

