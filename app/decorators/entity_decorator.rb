class EntityDecorator < Draper::Decorator
  include Api::Helpers::DecoratorHelper

  decorates Entity

  def link
    "dogood://users/#{object.link_id}"
  end
end


