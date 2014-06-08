class TagSerializer < ActiveModel::Serializer
  # cached
  # delegate :cache_key, to: :object

  attributes :name
end
