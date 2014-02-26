require 'test_helper'

class GoodJSONDecoratorTest < DoGood::TestCase
  def expected_hash
    {
      "id" => @good.object.id,
      "caption" => @good.object.caption,
      "current_user_commented" => true,
      "current_user_regooded" => false,
      "current_user_liked" => true
    }
  end

  def setup
    super

    Timecop.freeze(Time.local(2013))

    @good = FactoryGirl.create(:good)
    @good = GoodJSONDecorator.decorate(@good)
    stub(@good).current_user_commented { true }
    stub(@good).current_user_liked { true }
    stub(@good).current_user_regooded { false }
  end

  context "to_builder" do
    test "with defaults" do
      json = JSON.load(@good.to_builder.target!)
      assert_hashes_equal(expected_hash, json)
    end
  end
end

