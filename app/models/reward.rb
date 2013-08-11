class Reward < ActiveRecord::Base
  # has_many_and_belongs_to :user, :through => :claimed_reward
  # belongs_to :user, :through => :claimed_reward
  has_many :claimed_rewards
  has_many :users, :through => :claimed_rewards
  belongs_to :user
end
