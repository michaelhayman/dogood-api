require 'test_helper'

class TagDecoratorTest < DoGood::TestCase
  def setup
    super

    @tag = FactoryGirl.create(:tag).decorate
  end

  test "tag name" do
    assert_equal @tag.object.title, @tag.name
  end
end

