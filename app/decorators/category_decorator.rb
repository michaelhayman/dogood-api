class CategoryDecorator < BaseDecorator
  decorates Category

  def colour
    "##{object.colour}"
  end
end

