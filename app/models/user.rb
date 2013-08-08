class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  acts_as_followable
  acts_as_follower
  acts_as_liker

  has_many :goods
  has_many :regoods
  has_many :claimed_rewards
end
