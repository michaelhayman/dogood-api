class CategorySerializer < ActiveModel::Serializer
  # cached
  # delegate :cache_key, to: :object

  attributes :id,
    :name,
    :name_constant,
    :colour,
    :image_url
end
