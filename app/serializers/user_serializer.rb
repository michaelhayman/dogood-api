class UserSerializer < ActiveModel::Serializer
  # cached
  # delegate :cache_key, to: :object

  attributes :id,
    :slug,
    :avatar_url,
    :full_name
end
