class UserSerializer < ActiveModel::Serializer
  attributes :id, :logged_in, :email
end

class User < ActiveRecord::Base
  devise :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :validatable,
    :authentication_keys => [:username]

  attr_accessor :logged_in, :username
  # attr_accessible :username, :email, :password,
  #   :password_confirmation, :remember_me, :login

  validates :username,
    :uniqueness => {
      :case_sensitive => false
    }
  # validates_uniqueness_of :username
  validates_presence_of :username
  validates :username, length: { in: 4..20 }

  acts_as_followable
  acts_as_follower

  acts_as_voter

  has_many :goods
  has_many :claimed_rewards
  has_many :rewards, :through => :claimed_rewards
  has_many :comments

  # def find_for_database_authentication
  # def find_for_authentication

  # def self.find_first_by_auth_conditions(warden_conditions)
  #   conditions = warden_conditions.dup
  #   logger.debug "conditions! #{conditions}"
  #   if login = conditions.delete(:email)
  #     where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
  #   else
  #     where(conditions).first
  #   end
  # end

 # def self.find_first_by_auth_conditions(warden_conditions)
 #    conditions = warden_conditions.dup
 #    logger.debug "conditions! #{conditions}"
 #    conditions.delete(:password)
 #    if login = conditions.delete(:username)
 #      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
 #    else
 #      where(conditions).first
 #    end
 #    logger.debug "getting to here"
 #  end

  def self.find_for_database_authentication(user)
    logger.debug "to this condition #{user}"
    self.where("lower(username) = ?", user[:username].downcase).first ||
    self.where("lower(email) = ?", user[:username].downcase).first
  end
end
