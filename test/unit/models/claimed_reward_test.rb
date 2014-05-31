require 'test_helper'

class ClaimedRewardTest < DoGood::TestCase
  context "validations" do
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
      user: @user)
  end

  context "functionality" do
    test "should withdraw points" do
      assert FactoryGirl.build(:claimed_reward).valid?
    end
  end

  xtest "refund points"

  context "create claim" do
    test "no claim if no reward" do
      @claimed_reward.reward.destroy
      refute @claimed_reward.create_claim
    end

    test "no claim if no budget" do
      refute @claimed_reward.create_claim
    end

    test "claim otherwise" do
      original_qty = @claimed_reward.reward.quantity_remaining
      @user.add_points(10000, category: 'Bonus')
      assert @claimed_reward.create_claim
      assert_equal @claimed_reward.reward.quantity_remaining, original_qty - 1
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
