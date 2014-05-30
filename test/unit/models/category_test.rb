require 'test_helper'

class CategoryTest < DoGood::TestCase
  context "has validations" do
    def setup
      super
    end

    test "should have a name" do
      assert FactoryGirl.build(:category).valid?
      refute FactoryGirl.build(:category, name: "").valid?
    end
  end

  context "scopes" do
    def setup
      super
      Category.destroy_all
    end

    test "should be ordered alphabetically" do
      @health = FactoryGirl.create(:category, :health)
      @environment = FactoryGirl.create(:category)
      @care = FactoryGirl.create(:category, :care)

      @alphabetical = Category.alphabetical

      assert_equal [ @care, @environment, @health ], @alphabetical
      refute_equal [ @health, @care, @environment ], @alphabetical
    end
  end

  context "add_constant" do
    test "add name constant" do
      @health = FactoryGirl.create(:category, :health)
      @health.add_constant
      assert_equal "health", @health.name_constant
    end
  end

  context "image_url" do
    test "the image url" do
      @health = FactoryGirl.create(:category, :health)
      assert_equal "http://reciprocity-development.s3.amazonaws.com/categories/icon_menu_health.png", @health.image_url
    end
  end
end
