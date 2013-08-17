class UserSerializer < ActiveModel::Serializer
  attributes :id,
    :logged_in,
    :email,
    :username,
    :avatar,
    :full_name

  def avatar
    object.avatar.url
  end

  def name
    object.username
  end
end

class ExtraUserAttributesSerializer < ActiveModel::Serializer
  attributes :current_user_following,
    :followers_count,
    :following_count,
    :liked_goods_count,
    :points,
    :posted_or_followed_goods_count

  def current_user_following
    object.following?(object)
  end

  def followers_count
    object.follows_count
  end

  def following_count
    object.following_users_count
  end

  def liked_goods_count
    Good.liked_by_user(object.id).count
  end

  def posted_or_followed_goods_count
    Good.posted_or_followed_by(object.id).count
  end
end

class FullUserSerializer < ActiveModel::Serializer
  def serializable_hash
    u = UserSerializer.new(object, options).serializable_hash
    e = ExtraUserAttributesSerializer.new(object, options).serializable_hash
    u.merge e
  end
end

class User < ActiveRecord::Base
  devise :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :validatable,
    :authentication_keys => [:username]

  mount_uploader :avatar, AvatarUploader

  acts_as_followable
  acts_as_follower

  acts_as_voter

  has_many :goods
  has_many :claimed_rewards
  has_many :rewards, :through => :claimed_rewards
  has_many :owned_rewards, :class_name => "Reward", :source => :vendor
  has_many :comments

  attr_accessor :logged_in #, :username

  validates :username,
    :uniqueness => {
      :case_sensitive => false
    }
  validates_presence_of :username
  validates :username, length: { in: 4..20 }

  def self.find_for_database_authentication(user)
    self.where("lower(username) = ?", user[:username].downcase).first ||
    self.where("lower(email) = ?", user[:username].downcase).first
  end

  def self.by_id(user_id)
    where(:id => user_id).first
  end
end
