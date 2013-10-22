class Entity < ActiveRecord::Base
  belongs_to :entityable,
    :polymorphic => true

  validates :link,
    presence: { message: "Entities must have a link." }

  validates :link_id,
    presence: { message: "Entities must be linked with a model id." }

  validates :link_type,
    presence: { message: "Entities must have a link type." }

  validates :title,
    presence: { message: "Entities must have a title." }

  validates :entityable_id,
    presence: { message: "Entities must be based on a model id." }

  validates :entityable_type,
    presence: { message: "Entities must be based on a model type." }

  validates :range,
    presence: { message: "Enter a range." }
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
