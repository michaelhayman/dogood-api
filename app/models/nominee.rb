class Nominee < ActiveRecord::Base
  mount_uploader :avatar, NomineeAvatarUploader

  has_one :good

  validates :full_name,
    presence: { message: "Enter nominee's name." },
    length: { maximum: 40, message: "Please enter a shorter name." }
end

class NomineeSerializer < ActiveModel::Serializer
  attributes :full_name,
    :avatar,
    :email,
    :phone,
    :user_id,
    :twitter_id,
    :facebook_id

  def avatar
    object.avatar.url
  end
end
