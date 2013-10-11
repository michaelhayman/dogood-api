class Good < ActiveRecord::Base
  include DoGood::Reportable

  mount_uploader :evidence, EvidenceUploader

  acts_as_commentable
  has_many :summarized_comments, -> {
      limit(5)
    },
    :class_name => "Comment",
    :as => :commentable,
    :dependent => :destroy

  acts_as_followable

  acts_as_votable

  reportable!

  attr_accessor :current_user_liked,
    :current_user_commented,
    :current_user_regooded

  belongs_to :category
  belongs_to :user
  has_many :user_likes

  validate :caption,
    :message => "Enter a name."
  validate :caption,
    length: { maximum: 120 },
    message: "Please enter a shorter caption."
  validate :user_id,
    :message => "Goods must be associated with a user."
  validates_presence_of :evidence,
    :message => "C'mon, upload a photo."

  def self.in_category(id)
    where(:category_id => id)
  end

  def self.most_relevant
    limit(10)
  end

  def self.by_user(id)
    where(:user_id => id)
  end

  def self.specific(id)
    where("id = ?", id)
  end

  def self.liked_by_user(user_id)
    @user = User.by_id(user_id)
    @user.get_voted Good
  end

  def self.posted_or_followed_by(user_id)
    @user = User.by_id(user_id)

    @goods_posted_by_user = Good.by_user(@user)
    @goods_followed_by_user = @user.follows_by_type("Good".constantize).
      map(&:followable)
    @goods_posted_by_user.merge(@goods_followed_by_user)
  end

  def self.just_created_by(user_id)
    # where("user_id = ? AND created_at > ?", user_id, 1.minute.ago)
    where("user_id = ? AND created_at > ?", user_id, 60.seconds.ago)
  end

  def self.stream(current_user)
    # .not_blocked
    # @goods = Good.includes(:user).
    # @goods = Good.#includes(:user, :comments => :user).
    @goods = Good.includes(:user, :category, :comments => :user).
      order("goods.created_at desc").
      load

    @good_ids = @goods.map(&:id)

    @current_user_likes = current_user.
      votes.
      where(:votable_type => "Good",
            :votable_id => @good_ids).
      map(&:votable_id)

    @current_user_comments = current_user.
      comments.unlimited.
      where(:commentable_type => "Good",
            :commentable_id => @good_ids).
      map(&:commentable_id)

    @current_user_regoods = current_user.
      follows.
      where(:followable_type => "Good",
            :followable_id => @good_ids).
      map(&:followable_id)

    @goods.each do |g|
      g.current_user_liked = @current_user_likes.include?(g.id)
      g.current_user_commented = @current_user_comments.include?(g.id)
      g.current_user_regooded = @current_user_regoods.include?(g.id)
    end
  end

end

class GoodSerializer < ActiveModel::Serializer
  def serializable_hash
    current_user_good_serializer_hash.merge defaults_serializer_hash
  end

  private

  def current_user_good_serializer_hash
    CurrentUserGoodSerializer.new(object, options).serializable_hash
  end

  def defaults_serializer_hash
    DefaultsSerializer.new(object, options).serializable_hash
  end
end

class DefaultsSerializer < ActiveModel::Serializer
  # cached
  # delegate :cache_key, to: :object

  attributes :id,
    :caption,
    :likes_count,
    :comments_count,
    :regoods_count,
    :lat,
    :lng,
    :location_name,
    :location_image,
    :evidence,
    :user

  has_many :comments, polymorphic: true
  has_one :category

  def comments
    object.comments.summary
  end

  def evidence
    object.evidence.url
  end

  def likes_count
    object.cached_votes_up
  end

  def regoods_count
    object.follows_count
  end
end

class CurrentUserGoodSerializer < ActiveModel::Serializer
  # cached

  attributes :current_user_liked,
    :current_user_commented,
    :current_user_regooded

  def cache_key
    [object, current_user]
  end
end

