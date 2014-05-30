class NomineeSerializer < ActiveModel::Serializer
  # cached
  # delegate :cache_key, to: :object

  attributes :full_name,
    :avatar_url
end
