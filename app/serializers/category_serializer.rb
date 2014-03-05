class CategorySerializer < ActiveModel::Serializer
  cached

  attributes :id,
    :name,
    :name_constant,
    :colour,
    :image_url

  def cache_key
    object
  end
end
