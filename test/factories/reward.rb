FactoryGirl.define do
  factory :reward do
    cost 5000
    title "Air Canada Flight"
    subtitle "To Vegas"
    quantity 50
    quantity_remaining 10
    trait :unavailable do
      quantity_remaining 0
    end
  end
end

