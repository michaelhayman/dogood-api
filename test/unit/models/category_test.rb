class CategoryTest < DoGood::TestCase
  test "should have a name" do
    assert FactoryGirl.build(:category).valid?
    refute FactoryGirl.build(:category, name: "").valid?
  end

  test "should be ordered alphabetically" do
    @health = FactoryGirl.create(:category, :health)
    @environment = FactoryGirl.create(:category)
    @care = FactoryGirl.create(:category, :care)

    @alphabetical = Category.alphabetical

    assert_equal [ @care, @environment, @health ], @alphabetical
    refute_equal [ @health, @care, @environment ], @alphabetical
  end

  test "add name constant" do
    @health = FactoryGirl.create(:category, :health)
    @health.add_constant
    assert_equal "health", @health.name_constant
  end

  test "the image url" do
    @health = FactoryGirl.create(:category, :health)
    assert_equal "http://reciprocity-development.s3.amazonaws.com/categories/icon_menu_health.png", @health.image_url
  end
end
