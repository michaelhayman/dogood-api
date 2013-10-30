class Good < ActiveRecord::Base
  include DoGood::Reportable

  include SimpleHashtag::Hashtaggable
  hashtaggable_attribute :caption

  GOOD_POINTS = 10

  mount_uploader :evidence, EvidenceUploader

  acts_as_commentable

  acts_as_followable

  acts_as_votable

  reportable!

  attr_accessor :current_user_liked,
    :current_user_commented,
    :current_user_regooded

  belongs_to :category
  belongs_to :user
  has_many :user_likes

  validates :caption,
    presence: { message: "Enter a name." },
    length: { maximum: 120, message: "Please enter a shorter caption." }
  validates :user_id,
    presence: { message: "Goods must be associated with a user." }

  scope :standard, -> { limit(20) }

  scope :newest_first, -> {
    order("goods.created_at desc")
  }

  def add_points
    Point.record_points("Good", self.id, "Post", self.user_id, nil, GOOD_POINTS)
  end

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
    goods_table = Good.arel_table
    follows_table = Follow.arel_table

    includes(:followings).
      where(goods_table[:user_id].eq(user_id).
      or(follows_table[:follower_id].eq(user_id))).
      references(:followings)
  end

  def self.just_created_by(user_id)
    # where("user_id = ? AND created_at > ?", user_id, 1.minute.ago)
    where("user_id = ? AND created_at > ?", user_id, 60.seconds.ago)
  end

  def self.extra_info(current_user)
    includes(:user, :category, :comments => [ :user, :entities ])
  end

  def self.meta_stream(goods, current_user)
    @good_ids = goods.map(&:id)

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

    goods.each do |g|
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
    :done

  has_many :comments, polymorphic: true
  has_one :category
  has_one :user, serializer: BasicUserSerializer

  def comments
    object.comments.first(5)
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

  def cache_key
    [object, current_user]
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

