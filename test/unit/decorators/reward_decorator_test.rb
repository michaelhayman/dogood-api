class RewardDecoratorTest < DoGood::TestCase
  def setup
    super

    @reward = FactoryGirl.create(:reward).decorate
  end

  test "teaser" do
    assert_equal @reward.teaser, @reward.object.teaser.url
  end
end

