class Entity < ActiveRecord::Base
  belongs_to :entityable,
    polymorphic: true

  validates :link_type,
    presence: { message: "Entities must have a link type." }

  validates :link_id,
    presence: { message: "Entities must have a link id." }

  validates :title,
    presence: { message: "Entities must have a title." }

  validates :entityable_type,
    presence: { message: "Entities must be based on a model type." }

  validates :entityable_id,
    presence: { message: "Entities must be associated with a record." }

  validates :range,
    presence: { message: "Enter a range." }

  before_validation :add_link_id

  def add_link_id
    self.link_id = self.entityable_id unless self.link_id.present? && self.link_id > 0
  end
end

