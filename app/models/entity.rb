class Entity < ActiveRecord::Base
  belongs_to :entityable,
    :polymorphic => true
end

class EntitySerializer < ActiveModel::Serializer
  attributes :id,
    :link,
    :link_type,
    :link_id,
    :title,
    :range,
    :entityable_type,
    :entityable_id

  def link
    "dogood://users/#{object.link_id}"
  end
end
