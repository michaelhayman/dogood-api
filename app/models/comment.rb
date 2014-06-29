class Comment < ActiveRecord::Base
  include ActsAsCommentable::Comment

  COMMENT_POINTS = 3

  belongs_to :commentable,
    polymorphic: true,
    counter_cache: :cached_comments_count

  belongs_to :user

  belongs_to :good, counter_cache: :cached_comments_count

  has_many :entities, as: :entityable

  default_scope -> { order('created_at DESC') }

  # remove limit here
  scope :unlimited, -> { limit(500) }
  scope :summary, -> { limit(5) }

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  validates_presence_of :comment,
    message: "Enter a comment."

  validates_presence_of :user_id,
    message: "No user record found."

  validates_length_of :comment,
    minimum: 5,
    maximum: 120,
    allow_blank: false

  accepts_nested_attributes_for :entities

  def self.for_good(good_id)
    where(commentable_type: "Good", commentable_id: good_id)
  end

  def send_notification
    if self.user && self.good
      message = "#{self.user.full_name} posted a new comment on your post"
      url = "dogood://goods/#{self.commentable_id}"
      Resque.enqueue(SendNotification, self.good.user_id, message, url)
    end
  end
end

