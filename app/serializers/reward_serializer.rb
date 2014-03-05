class RewardSerializer < ActiveModel::Serializer
  attributes :id,
    :title,
    :subtitle,
    :teaser,
    :full_description,
    :cost,
    :quantity,
    :quantity_remaining

  has_one :user
end
