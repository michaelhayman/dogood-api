class Entity < ActiveRecord::Base
  belongs_to :entityable,
    polymorphic: true

  validates :link_type,
    presence: { message: "Entities must have a link type." }

  validates :title,
    presence: { message: "Entities must have a title." }

  validates :entityable_type,
    presence: { message: "Entities must be based on a model type." }

  validates :entityable_id,
    presence: { message: "Entities must be associated with a record." }

  validates :range,
    presence: { message: "Enter a range." }

  before_save :add_link_id

  def add_link_id
    self.link_id = self.entityable_id unless link_id_present?
  end

  def link_id_present?
    if self.link_id.present?
      if self.link_id == 0
        false
      else
        true
      end
    else
      false
    end
  end
end

