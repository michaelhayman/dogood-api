require 'test_helper'

class ClaimedRewardTest < DoGood::TestCase
  xtest "validations"
  xtest "test claimed rewards"

  def setup
    super
    @user = FactoryGirl.create(:user)
    @claimed_reward = FactoryGirl.create(
      :claimed_reward,
      :user_id => @user.id)
  end

  context "has validations" do
    test "should withdraw points" do
      assert FactoryGirl.build(:claimed_reward).valid?
    end
  end

  context "point management" do
    test "should withdraw points" do
      point = FactoryGirl.create(
        :point,
        :to_user_id => @user.id)

      points = @user.points

      @claimed_reward.withdraw_points

      assert_equal @user.points, points - @claimed_reward.reward.cost
    end
  end

  context "within_budget?" do
    test "is within budget" do
      assert @claimed_reward.within_budget?(50000)
    end

    test "is not within budget" do
      refute @claimed_reward.within_budget?(0)
    end

    test "deals with objects missing" do
      stub(@claimed_reward).reward { false }
      refute @claimed_reward.within_budget?(500)
    end
  end
end
