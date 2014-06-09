FactoryGirl.define do
  factory :tag do
    title "#awesome"
    link_type "tag"
    range ["0", "6"]
    entityable_id 112
    entityable_type "Comment"

    trait :cool do
      title "#cool"
    end

    trait :weird do
      title "#weird"
    end
  end
end

