class Good < ActiveRecord::Base
  acts_as_commentable
  acts_as_followable

  acts_as_votable

  attr_accessor :current_user_liked,
    :current_user_commented,
    :current_user_regooded

  belongs_to :category
  belongs_to :user
  has_many :regoods
  has_many :user_likes

  validate :caption, :message => "Enter a name."
  validate :user_id, :message => "Goods must be associated with a user."

  def self.in_category(id)
    where(:category_id => id)
  end

  def self.by_user(id)
    where(:user_id => id)
  end

  def self.stream(current_user)
    @goods = Good.includes(:comments => :user).load

    @good_ids = @goods.map(&:id)

    @current_user_likes = current_user.
      votes.
      where(:votable_type => "Good",
            :votable_id => @good_ids).
      map(&:votable_id)

    @current_user_comments = current_user.
      comments.
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
    current_user_serializer_hash.merge defaults_serializer_hash
  end

  private

  def current_user_serializer_hash
    CurrentUserSerializer.new(object, options).serializable_hash
  end

  def defaults_serializer_hash
    DefaultsSerializer.new(object, options).serializable_hash
  end
end

class DefaultsSerializer < ActiveModel::Serializer
  cached
  delegate :cache_key, to: :object

  attributes :id,
    :caption,
    :likes,
    :comments_count,
    :comments

  has_many :comments

  def likes
    object.cached_votes_up
  end
end

class CurrentUserSerializer < ActiveModel::Serializer
  cached

  attributes :current_user_liked,
    :current_user_commented,
    :current_user_regooded

  def cache_key
    [object, current_user]
  end
end

