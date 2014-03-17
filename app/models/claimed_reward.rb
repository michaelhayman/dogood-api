class ClaimedReward < ActiveRecord::Base
  belongs_to :user
  belongs_to :reward
  scope :recent, -> { order('created_at DESC') }

  def withdraw_points
    user.subtract_points(self.reward.cost)
  end

  def refund_points
  end

  def within_budget?(budget)
    if self.reward && self.reward.cost
      budget > self.reward.cost
    else
      false
    end
  end
end
