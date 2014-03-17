class ClaimedReward < ActiveRecord::Base
  belongs_to :user
  belongs_to :reward

  scope :recent, -> { order('created_at DESC') }

  validates_presence_of :user,
    presence: {
      message: "Enter a user."
    }
  validates_presence_of :reward,
    presence: {
      message: "Enter a reward."
    }

  def withdraw_points
    user.subtract_points(self.reward.cost)
  end

  def create_claim
    errors.add(:base, "Reward no longer available.") unless self.reward && self.reward.is_available?
    errors.add(:base, "Insufficient points.") if !self.within_budget?(self.user.points)

    if errors.empty?
      self.withdraw_points
      self.save
      return true
    else
      return false
    end
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
