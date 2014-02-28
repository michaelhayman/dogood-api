require 'test_helper'

class TagDecoratorTest < DoGood::TestCase
  def expected_hash
    tag = @tag.object
    {
      "id" => tag.id,
      "name" => tag.name
    }
  end

  def setup
    super

    @tag = FactoryGirl.create(:tag)
    @tag = TagDecorator.decorate(@tag)
  end

  context "to_builder" do
    test "with defaults" do
      json = JSON.load(@tag.to_builder.target!)
      assert_hashes_equal(expected_hash, json)
    end
  end
end

