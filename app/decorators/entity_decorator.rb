class EntityDecorator < BaseDecorator
  decorates Entity

  def link
    if object.link_type == "user"
      "dogood://users/#{object.link_id}"
    else
      "dogood://tagged/#{object.title}"
    end
  end
end

