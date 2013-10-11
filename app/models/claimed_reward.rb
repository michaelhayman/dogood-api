class ClaimedReward < ActiveRecord::Base
  belongs_to :user
  belongs_to :reward
  scope :recent, -> { order('created_at DESC') }
end
