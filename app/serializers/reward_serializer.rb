class RewardSerializer < ActiveModel::Serializer
  # cached
  # delegate :cache_key, to: :object

  attributes :id,
    :title,
    :subtitle,
    :teaser,
    :full_description,
    :cost,
    :quantity,
    :quantity_remaining,
    :instructions,
    :within_budget

  has_one :user
end
