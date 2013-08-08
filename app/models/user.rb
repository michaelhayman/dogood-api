class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  has_many :goods
  has_many :comments
  has_many :user_rewards
  has_many :regoods
  has_many :goods, :as => :likes
end
