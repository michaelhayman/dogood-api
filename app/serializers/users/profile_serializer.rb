class Users::ProfileSerializer < ActiveModel::Serializer
  attributes :id,
    :avatar_url,
    :full_name,
    :location,
    :current_user_following,
    :followers_count,
    :following_count,
    :liked_goods_count,
    :points,
    :posted_or_followed_goods_count
end

