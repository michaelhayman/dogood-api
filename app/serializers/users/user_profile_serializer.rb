class UserSerializer < ActiveModel::Serializer
  attributes :id,
    :logged_in,
    :email,
    :avatar_url,
    :full_name,
    :location,
    # N+1
    :current_user_following

  # N+1
  def current_user_following
    nil
    # if  current_user
    #   current_user.following?(object)
    # else
    #   nil
    # end
  end
end

class CurrentUserSerializer < ActiveModel::Serializer
  attributes :id,
    :email,
    :full_name,
    :location,
    :biography,
    :full_name,
    :points,
    :avatar,
    :phone,
    :twitter_id,
    :facebook_id
end

class ExtraUserAttributesSerializer < ActiveModel::Serializer
  attributes :current_user_following,
    :followers_count,
    :following_count,
    :liked_goods_count,
    :points,
    :posted_or_followed_goods_count

  def current_user_following
    if current_user
      current_user.following?(object)
    end
  end

  def followers_count
    object.follows_count
  end

  def following_count
    object.following_users_count
  end

  def liked_goods_count
    Good.liked_by_user(object.id).count
  end

  def posted_or_followed_goods_count
    Good.posted_or_followed_by(object.id).count
  end
end

class FullUserSerializer < ActiveModel::Serializer
  def serializable_hash
    u = UserSerializer.new(object, options).serializable_hash
    e = ExtraUserAttributesSerializer.new(object, options).serializable_hash
    u.merge e
  end
end

