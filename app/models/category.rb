class Category < ActiveRecord::Base
  has_many :goods
end

class CategorySerializer < ActiveModel::Serializer
  cached

  attributes :id,
    :name

  def image_url
    # "/assets/
    # object.teaser.url
  end

  def cache_key
    object
  end
end
