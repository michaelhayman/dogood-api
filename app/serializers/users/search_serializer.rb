class Users::SearchSerializer < ActiveModel::Serializer
  attributes :id,
    :full_name,
    :avatar_url,
    :location,
    :current_user_following
end

