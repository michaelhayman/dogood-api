class TagDecorator < EntityDecorator
  decorates Tag

  def name
    object.title
  end
end

