FactoryGirl.define do
  factory :entity do
    link "dogood://users/2"
    link_id 2
    link_type "user"
    title "Coyote"
    entityable_id 112
    entityable_type "Comment"
    range "temporary_workaround"
    after(:create) do |instance|
      instance.range = ["0", "7"]
    end
  end
end

