require 'test_helper'

class ClaimedRewardTest < DoGood::TestCase
  context "has validations" do
    def setup
      super
    end

    test "should be valid by default" do
      assert FactoryGirl.build(:claimed_reward).valid?
    end

    test "has a user" do
      refute FactoryGirl.build(:claimed_reward, :no_user).valid?
    end

    test "has a reward" do
      refute FactoryGirl.build(:claimed_reward, :no_reward).valid?
    end
  end

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
      @user.add_points(10000, category: 'Bonus')
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
