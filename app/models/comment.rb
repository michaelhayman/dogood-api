class Comment < ActiveRecord::Base

  include ActsAsCommentable::Comment

  belongs_to :commentable, :polymorphic => true, :counter_cache => :comments_count

  default_scope -> { order('created_at ASC') }

  scope :overview, -> { limit(1) }

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  # NOTE: Comments belong to a user
  belongs_to :user
end

class CommentSerializer < ActiveModel::Serializer
  attributes :comment,
    :user_id

  has_one :user
end
