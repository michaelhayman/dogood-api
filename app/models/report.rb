class Report < ActiveRecord::Base
  belongs_to :reportable,
    polymorphic: true

  validates_uniqueness_of :user_id,
    scope: [
      :reportable_id,
      :reportable_type
    ],
    message: "may only file one report."

  validates_presence_of :user_id,
    :reportable_id,
    :reportable_type
end
