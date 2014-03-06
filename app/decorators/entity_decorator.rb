class EntityDecorator < BaseDecorator
  decorates Entity

  def link
    "dogood://users/#{object.link_id}"
  end
end


