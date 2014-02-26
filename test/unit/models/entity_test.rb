require 'test_helper'

class EntityTest < DoGood::TestCase
  context "has validations" do
    test "should be valid with all default values" do
      assert FactoryGirl.build(:entity).valid?
    end

    test "should have a link" do
      refute FactoryGirl.build(:entity, link: "").valid?
    end

    test "should have a link id" do
      refute FactoryGirl.build(:entity, link_id: "").valid?
    end

    test "should have a link type" do
      refute FactoryGirl.build(:entity, link_type: "").valid?
    end

    test "should have a title" do
      refute FactoryGirl.build(:entity, title: "").valid?
    end

    test "have entityable id as optional attribute" do
      assert FactoryGirl.build(:entity, entityable_id: "").valid?
    end

    test "should have a entityable type" do
      refute FactoryGirl.build(:entity, entityable_type: "").valid?
    end

    test "should have a range" do
      refute FactoryGirl.build(:entity, range: "").valid?
    end
  end
end

