require 'test_helper'

class RewardDecoratorTest < DoGood::TestCase
  def expected_hash
    reward = @reward.object
    {
      "id" => reward.id,
      "title" => reward.title
    }
  end

  def setup
    super

    @reward = FactoryGirl.create(:reward)
    @reward = RewardDecorator.decorate(@reward)
  end

  context "to_builder" do
    test "with defaults" do
      json = JSON.load(@reward.to_builder.target!)
      assert_hashes_equal(expected_hash, json)
    end
  end
end

