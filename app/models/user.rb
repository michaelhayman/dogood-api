class User < ActiveRecord::Base
  has_merit

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

  validates :full_name,
    presence: {
      message: "Enter a name."
    },
    length: {
      maximum: 35,
      message: "Please enter a shorter name."
    },
    format: {
      with: /^([^\d\W]|[-]|[\s])*$/,
      multiline: true,
      message: "Please enter a valid name."
    }

  attr_accessor :logged_in
  attr_accessor :message

  RANKS = %w{ E D C B A }.deep_freeze

  def self.by_id(user_id)
    where(:id => user_id).first
  end

  def valid_name?
    self.valid?

    if !self.errors[:full_name].any?
      return true
    end
    return false
  end

  def rank
    RANKS[self.level]
  end

  def update_password(password)
    if !password[:current_password].blank? && !password[:password].blank? && !password[:password_confirmation].blank?
      self.update_with_password(password)
    else
      self.errors.add(:base, "New password can't be blank.")
      return false
    end
  end
end

