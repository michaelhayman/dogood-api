class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :logged_in

  acts_as_followable
  acts_as_follower
  acts_as_voter

  has_many :goods
  has_many :regoods
  has_many :claimed_rewards
  has_many :user_likes

end
