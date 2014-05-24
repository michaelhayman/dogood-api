class GoodSerializer < ActiveModel::Serializer
  def serializable_hash
    defaults_serializer_hash.merge current_user_good_serializer_hash
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
  cached

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
    :done,
    :created_at

  has_many :comments, polymorphic: true
  has_one :category
  has_one :user
  has_many :entities, :as => :entityable
  has_one :nominee

  def comments
    object.comments.last(5)
  end

  def comment_key
    if !object.comments.empty?
      object.comments.last.updated_at
    else
      "comment"
    end
  end

  def cache_key
    [object, comment_key, scope]
  end
end

class CurrentUserGoodSerializer < ActiveModel::Serializer
  cached

  attributes :current_user_liked,
    :current_user_commented,
    :current_user_regooded

  def cache_key
    [current_user_liked, current_user_commented, current_user_regooded, scope]
  end
end

