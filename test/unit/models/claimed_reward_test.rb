require 'test_helper'

class ClaimedRewardTest < DoGood::TestCase
  xtest "validations"
  xtest "test claimed rewards"

  context "has validations" do
    test "should withdraw points" do
      assert FactoryGirl.build(:claimed_reward).valid?
    end
  end

  context "point management" do
    test "should withdraw points" do
      user = FactoryGirl.create(:user)
      point = FactoryGirl.create(
        :point,
        :to_user_id => user.id)

      points = user.points

      claimed_reward = FactoryGirl.create(
        :claimed_reward,
        :user_id => user.id)
      claimed_reward.withdraw_points

      assert_equal user.points, points - claimed_reward.reward.cost
    end
  end
end
