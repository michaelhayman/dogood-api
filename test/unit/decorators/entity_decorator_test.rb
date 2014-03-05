require 'test_helper'

class EntityDecoratorTest < DoGood::TestCase
  def setup
    super

    @entity = FactoryGirl.create(:entity)
    @entity = EntityDecorator.decorate(@entity)
  end

  test "link" do
    assert_equal "dogood://users/#{@entity.object.link_id}", @entity.link
  end
end

