require 'test_helper'

class CategoryDecoratorTest < DoGood::TestCase
  def setup
    super

    @category = FactoryGirl.create(:category).decorate
  end

  context "colour" do
    test "prefixed by #" do
      assert_equal @category.colour, "##{@category.object.colour.upcase}"
    end
  end
end

