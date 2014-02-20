FactoryGirl.define do
  factory :nominee do
    full_name "Michael Hayman"
    email Faker::Internet.email
    # good FactoryGirl.build(:good)
    # user FactoryGirl.build(:user)
  end
end

