class UserLikes < ActiveRecord::Base
  has_one :good
  has_one :user
end
