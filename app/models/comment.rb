class Comment < ActiveRecord::Base
  include ActsAsCommentable::Comment
  include SimpleHashtag::Hashtaggable

  hashtaggable_attribute :comment

  belongs_to :commentable,
    :polymorphic => true,
    :counter_cache => :comments_count

  belongs_to :user

  belongs_to :good, counter_cache: true

  has_many :entities, :as => :entityable

  default_scope -> { order('created_at DESC') }

  # remove limit here
  scope :unlimited, -> { limit(500) }
  scope :summary, -> { limit(5) }

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  validates_presence_of :comment,
    :message => "Enter a comment."

  validates_presence_of :user_id,
    :message => "No user record found."

  validates_length_of :comment,
    :minimum => 5,
    :maximum => 120,
    :allow_blank => false

  accepts_nested_attributes_for :entities

  def self.for_good(good_id)
    where(:commentable_type => "Good", :commentable_id => good_id)
  end
end

class CommentSerializer < ActiveModel::Serializer
  attributes :comment,
    :user_id,
    :created_at

  has_many :entities, :as => :entityable

  has_one :user, serializer: BasicUserSerializer
end
