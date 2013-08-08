class ClaimedReward < ActiveRecord::Base
  belongs_to :user
  belongs_to :reward
end
