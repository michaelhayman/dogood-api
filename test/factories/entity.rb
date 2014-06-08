FactoryGirl.define do
  factory :entity do
    # link_id 2
    link_type "user"
    title "Coyote"
    entityable_id 112
    entityable_type "Comment"
    range ["0", "6"]

    trait :tag do
      link_type "tag"
      title "#doggy"
      range ["0", "6"]
    end

    trait :no_link_id do
      link_id nil
    end

    trait :awesome do
      title "awesome"
      link_type "tag"
    end
  end
end

