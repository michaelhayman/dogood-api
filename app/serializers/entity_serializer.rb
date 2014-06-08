class EntitySerializer < ActiveModel::Serializer
  # cached
  # delegate :cache_key, to: :object

  attributes :id,
    :link,
    :link_type,
    :link_id,
    :title,
    :range
end
