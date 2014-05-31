class Reward < ActiveRecord::Base
  # has_many_and_belongs_to :user, through: :claimed_reward
  # belongs_to :user, through: :claimed_reward
  has_many :claimed_rewards
  has_many :users, through: :claimed_rewards
  belongs_to :user

  scope :recent, -> { order('created_at DESC') }

  mount_uploader :teaser, AvatarUploader

  # more than > 0
  validates_presence_of :cost
  validates_presence_of :title
  validates_presence_of :subtitle
  validates_presence_of :quantity
  validates_presence_of :quantity_remaining
  validates :quantity, numericality: {
    greater_than_or_equal_to: 1
  }
  validates :quantity_remaining, numericality: {
    less_than_or_equal_to: :quantity,
    greater_than_or_equal_to: 0
  }
  validates :cost, numericality: {
    greater_than_or_equal_to: 1
  }

  def self.sufficient_points(user)
    where("cost <= ?", user.points)
  end

  def self.available
    where("quantity_remaining > ?", 0)
  end

  def is_available?
    Reward.available.find_by_id(self.id)
  end

  def self.just_created_by(user_id)
    reward = where("user_id = ? AND created_at > ?", user_id, 60.seconds.ago)
    reward.present?
  end
end

