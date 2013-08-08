class Good < ActiveRecord::Base
  acts_as_commentable
  acts_as_votable

  attr_accessor :current_user_likes, :current_user_commented

  belongs_to :category
  belongs_to :user
  has_many :regoods
  has_many :user_likes

  validate :caption, :message => "Enter a name."
  validate :user_id, :message => "Goods must be associated with a user."
end

class GoodSerializer < ActiveModel::Serializer
  attributes :caption,
    :current_user_likes,
    :current_user_commented,
    :likes,
    :comments_count

  has_many :comments

  def comments
    object.comments.recent.overview
  end

  def likes
    object.cached_votes_up
  end
end

