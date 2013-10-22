class ClaimedReward < ActiveRecord::Base
  belongs_to :user
  belongs_to :reward
  scope :recent, -> { order('created_at DESC') }

  def withdraw_points
    Point.record_points(
      "ClaimedReward",
      self.id,
      "Claim",
      self.user_id,
      nil,
      - self.reward.cost)
  end

  def refund_points
  end
end
