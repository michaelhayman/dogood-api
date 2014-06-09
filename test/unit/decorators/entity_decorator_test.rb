require 'test_helper'

class EntityDecoratorTest < DoGood::TestCase
  test "link is a user" do
    @entity = FactoryGirl.create(:entity).decorate
    assert_equal "dogood://users/#{@entity.object.link_id}", @entity.link
  end

  test "link is a tag" do
    @entity = FactoryGirl.create(:entity, :tag).decorate
    assert_equal "dogood://goods/tagged/#{@entity.object.title}", @entity.link
  end
end

