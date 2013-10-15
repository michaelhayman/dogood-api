class Comment < ActiveRecord::Base
  include ActsAsCommentable::Comment
  include SimpleHashtag::Hashtaggable

  hashtaggable_attribute :comment

  belongs_to :commentable,
    :polymorphic => true,
    :counter_cache => :comments_count

  default_scope -> { order('created_at DESC') }

  # remove limit here
  scope :unlimited, -> { limit(500) }
  scope :summary, -> { limit(5) }

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  # NOTE: Comments belong to a user
  belongs_to :user

  validates_presence_of :comment,
    :message => "Enter a comment."

  def self.for_good(good_id)
    where(:commentable_type => "Good", :commentable_id => good_id)
  end
end

class CommentSerializer < ActiveModel::Serializer
  attributes :comment,
    :user_id

  has_one :user, serializer: BasicUserSerializer
end
