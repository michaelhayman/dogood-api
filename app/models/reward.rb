class Reward < ActiveRecord::Base
  # has_many_and_belongs_to :user, :through => :claimed_reward
  belongs_to :claimed_reward
end
