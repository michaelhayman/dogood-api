require 'test_helper'

class TagSerializerTest < DoGood::TestCase
  def expected_hash
    {
      tags: {
        "id" => @tag.id,
        "name" => @tag.name
      }
    }
  end

  def setup
    super

    @tag = FactoryGirl.create(:tag)
    @tag = TagDecorator.decorate(@tag)
    @serializer = TagSerializer.new @tag, root: "tags"
  end

  test "json for api" do
    assert_equal expected_hash.to_json, @serializer.to_json
  end
end

