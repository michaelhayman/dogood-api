require 'test_helper'

class CategorySerializerTest < DoGood::TestCase
  def expected_hash
    {
      categories: {
        id: @category.id,
        name: @category.name,
        name_constant: @category.name_constant,
        colour: @category.colour,
        image_url: @category.image_url
      }
    }
  end

  def setup
    super
    @user = FactoryGirl.create(:user)
    @category = FactoryGirl.create(:category, :health).decorate

    @serializer = CategorySerializer.new @category, root: "categories"
  end

  test "api" do
    assert_equal expected_hash.to_json, @serializer.to_json
  end
end

