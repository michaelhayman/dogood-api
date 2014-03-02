FactoryGirl.define do
  factory :tag do
    name "awesome"

    trait :cool do
      name "cool"
    end

    trait :weird do
      name "weird"
    end
  end
end

