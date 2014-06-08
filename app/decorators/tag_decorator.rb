class TagDecorator < BaseDecorator
  decorates Tag

  def name
    object.title
  end
end

