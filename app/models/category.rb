class Category < ActiveRecord::Base
  has_many :goods

  before_save :add_constant

  scope :alphabetical, -> {
    order('name asc')
  }

  def add_constant
    self.name_constant = self.name.parameterize
  end

  def image_url
    "http://#{CarrierWave::Uploader::Base.fog_directory}.s3.amazonaws.com/categories/icon_menu_#{self.name_constant}.png"
  end
end

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
