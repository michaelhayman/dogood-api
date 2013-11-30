class Nominee < ActiveRecord::Base
  mount_uploader :avatar, NomineeAvatarUploader

  belongs_to :good
end
