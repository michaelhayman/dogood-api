class User < ActiveRecord::Base
  include DoGood::Reportable

  devise :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :validatable

  mount_uploader :avatar, AvatarUploader

  acts_as_followable
  acts_as_follower

  acts_as_voter

  reportable!

  has_many :goods
  has_many :claimed_rewards
  has_many :rewards, :through => :claimed_rewards
  has_many :owned_rewards, :class_name => "Reward", :source => :vendor
  has_many :comments
  has_many :reports

  attr_accessor :logged_in

  def self.by_id(user_id)
    where(:id => user_id).first
  end

  def score
    Point.score_for_user(self.id)
  end

  def rank
    Point.rank_for_user(self.id)
  end

  def points
    Point.points_for_user(self.id)
  end
end

class UserSerializer < ActiveModel::Serializer
  attributes :id,
    :logged_in,
    :email,
    :avatar,
    :full_name,
    # N+1
    :current_user_following

  def avatar
    object.avatar.url
  end

  # N+1
  def current_user_following
    current_user.following?(object)
  end
end

class CurrentUserSerializer < ActiveModel::Serializer
  attributes :id,
    :email,
    :full_name,
    :location,
    :biography,
    :full_name,
    :points,
    :avatar,
    :phone,
    :twitter_id,
    :facebook_id

  def avatar
    object.avatar.url
  end
end

class BasicUserSerializer < ActiveModel::Serializer
  attributes :id,
    :avatar,
    :full_name

  def avatar
    object.avatar.url
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
    current_user.following?(object)
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

