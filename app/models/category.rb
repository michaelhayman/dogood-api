class Category < ActiveRecord::Base
  has_many :goods

  before_save :add_constant

  def add_constant
    self.name_constant = self.name.parameterize
  end
end

class CategorySerializer < ActiveModel::Serializer
  # cached

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
