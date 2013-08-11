class UserSerializer < ActiveModel::Serializer
  attributes :id, :logged_in, :email
end

class User < ActiveRecord::Base
  devise :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :validatable

  attr_accessor :logged_in

  acts_as_followable
  acts_as_follower

  acts_as_voter

  has_many :goods
  has_many :claimed_rewards
  has_many :rewards, :through => :claimed_rewards
  has_many :comments
end
