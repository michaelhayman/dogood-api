FactoryGirl.define do
  factory :device do
    token "asdf"
    provider "apns"
    is_valid true
    user
  end
end

