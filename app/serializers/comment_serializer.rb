class CommentSerializer < ActiveModel::Serializer
  # cached
  # delegate :cache_key, to: :object

  attributes :comment,
    :created_at

  has_many :entities, :as => :entityable

  has_one :user, serializer: UserSerializer
end
