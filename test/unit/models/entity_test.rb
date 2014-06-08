require 'test_helper'

class EntityTest < DoGood::TestCase
  test "should be valid with all default values" do
    assert FactoryGirl.build(:entity).valid?
  end

  test "should have a link id after saving" do
    @entity = FactoryGirl.build(:entity, link_id: "")
    @entity.save
    assert @entity.valid?
  end

  test "should have a link type" do
    refute FactoryGirl.build(:entity, link_type: "").valid?
  end

  test "should have a title" do
    refute FactoryGirl.build(:entity, title: "").valid?
  end

  test "have entityable id as optional attribute" do
    refute FactoryGirl.build(:entity, entityable_id: "").valid?
  end

  test "should have a entityable type" do
    refute FactoryGirl.build(:entity, entityable_type: "").valid?
  end

  test "should have a range" do
    refute FactoryGirl.build(:entity, range: "").valid?
  end

  test "should save with a link id based on entityable id if it doesn't exist" do
    @entity = FactoryGirl.build(:entity, :no_link_id)
    @entity.valid?
    assert_equal @entity.link_id, @entity.entityable_id
  end

  def teardown
    super
    Entity.destroy_all
  end
end

