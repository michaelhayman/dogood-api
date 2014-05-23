class Nominee < ActiveRecord::Base
  mount_uploader :avatar, NomineeAvatarUploader

  has_one :good
  belongs_to :user

  validates :full_name,
    presence: { message: "Enter nominee's name." },
    length: { maximum: 40, message: "Please enter a shorter name." }
end

