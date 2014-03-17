FactoryGirl.define do
  factory :claimed_reward do
    reward
    user

    trait :no_user do
      user nil
    end

    trait :no_reward do
      reward nil
    end
  end
end

