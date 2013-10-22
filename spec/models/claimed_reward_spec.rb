require 'spec_helper'

describe ClaimedReward do
  pending "validations"
  pending "test claimed rewards"

  context "has validations" do
    it "should withdraw points" do
      FactoryGirl.build(:claimed_reward).should be_valid
    end
  end

  context "point management" do
    it "should withdraw points" do
      user = FactoryGirl.create(:user)
      point = FactoryGirl.create(
        :point,
        :to_user_id => user.id)

      points = user.points

      claimed_reward = FactoryGirl.create(
        :claimed_reward,
        :user_id => user.id)
      claimed_reward.withdraw_points

      user.points.should eq(points - claimed_reward.reward.cost)
    end
  end
end

