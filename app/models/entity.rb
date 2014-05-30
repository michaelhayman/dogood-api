class Entity < ActiveRecord::Base
  belongs_to :entityable,
    polymorphic: true

  validates :link,
    presence: { message: "Entities must have a link." }

  validates :link_id,
    presence: { message: "Entities must be linked with a model id." }

  validates :link_type,
    presence: { message: "Entities must have a link type." }

  validates :title,
    presence: { message: "Entities must have a title." }

  validates :entityable_type,
    presence: { message: "Entities must be based on a model type." }

  validates :range,
    presence: { message: "Enter a range." }
end

