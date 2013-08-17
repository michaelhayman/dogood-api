class Reward < ActiveRecord::Base
  # has_many_and_belongs_to :user, :through => :claimed_reward
  # belongs_to :user, :through => :claimed_reward
  has_many :claimed_rewards
  has_many :users, :through => :claimed_rewards
  belongs_to :user

  mount_uploader :teaser, AvatarUploader

  # more than > 0
  validates_presence_of :cost
  validates_presence_of :title
  validates_presence_of :subtitle
  validates_presence_of :quantity
  validates_presence_of :quantity_remaining

  def self.sufficient_points(user)
    where("cost <= ?", user.points)
  end

  def self.available(user)
    where("quantity_remaining > ?", 0)
  end
end

class RewardSerializer < ActiveModel::Serializer
  attributes :id,
    :title,
    :subtitle,
    :teaser,
    :full_description,
    :user_id,
    :cost,
    :quantity,
    :quantity_remaining

  has_one :user

  def teaser
    object.teaser.url
  end
end
