class CategoryDecorator < BaseDecorator
  decorates Category

  def colour
    "##{object.colour}".upcase
  end
end

