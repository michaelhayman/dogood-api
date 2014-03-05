class EntitySerializer < ActiveModel::Serializer
  attributes :id,
    :link,
    :link_type,
    :link_id,
    :title,
    :range,
    :entityable_type,
    :entityable_id
end
