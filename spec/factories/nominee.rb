FactoryGirl.define do
  factory :nominee do
    full_name "Michael Hayman"
    email Faker::Internet.email
  end
end

