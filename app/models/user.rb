class User < ActiveRecord::Base
  include DoGood::Reportable

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

  reportable!

  has_many :goods
  has_many :claimed_rewards
  has_many :rewards, :through => :claimed_rewards
  has_many :owned_rewards, :class_name => "Reward", :source => :vendor
  has_many :comments
  has_many :reports

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

  def score
    goods = Good.where(:user_id => self.id)

    weight = 1.0
    score = 0.0
    goods.each do |g|
      if g.created_at > 7.days.ago
        weight = 1
      elsif g.created_at > 30.days.ago
        weight = 0.8
      elsif g.created_at > 60.days.ago
        weight = 0.6
      elsif g.created_at > 90.days.ago
        weight = 0.3
      else
        weight = 0.1
      end
      # logger.debug "#{g.id} #{time_ago_in_words(g.created_at)} - #{weight} * #{g.points}"
      score += (g.points * weight)
    end

    return score
  end

  def points
    Point.points_for_user(self.id)
  end
end

# need to drop email, logged_in, etc from
# this base serializer.
class UserSerializer < ActiveModel::Serializer
  attributes :id,
    :logged_in,
    :email,
    :username,
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

  # def good_score
  #   require 'RMagick'

  #   # Demonstrate the annotate method
  #   Text = 'RMagick'

  #   granite = Magick::ImageList.new('granite:')
  #   canvas = Magick::ImageList.new
  #   canvas.new_image(300, 100, Magick::TextureFill.new(granite))

  #   text = Magick::Draw.new
  #   text.font_family = 'helvetica'
  #   text.pointsize = 52
  #   text.gravity = Magick::CenterGravity

  #   text.annotate(canvas, 0,0,2,2, Text) {
  #      self.fill = 'gray83'
  #   }

  #   text.annotate(canvas, 0,0,-1.5,-1.5, Text) {
  #      self.fill = 'gray40'
  #   }

  #   text.annotate(canvas, 0,0,0,0, Text) {
  #      self.fill = 'darkred'
  #   }

  #   canvas.write('rubyname.gif')
  #   exit
  # end
end

class CurrentUserSerializer < ActiveModel::Serializer
  attributes :id,
    :email,
    :location,
    :biography,
    :full_name,
    :username,
    :points,
    :avatar,
    :phone,
    :twitter_id,
    :facebook_id
  # connected, etc...

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

