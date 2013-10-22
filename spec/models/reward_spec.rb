require 'spec_helper'

describe Reward do
  context "has validations" do
    it "should be valid" do
      FactoryGirl.build(:reward).should be_valid
    end

    it "should be not be valid without a cost" do
      FactoryGirl.build(:reward, :cost => "").should_not be_valid
    end

    it "should be not be valid without a title" do
      FactoryGirl.build(:reward, :title => "").should_not be_valid
    end

    it "should be not be valid without a subtitle" do
      FactoryGirl.build(:reward, :subtitle => "").should_not be_valid
    end

    it "should be not be valid without a quantity" do
      FactoryGirl.build(:reward, :quantity => "").should_not be_valid
    end

    it "should be not be valid without a quantity remaining" do
      FactoryGirl.build(:reward, :quantity_remaining => "").should_not be_valid
    end
  end

  it "should show no rewards if the user has insufficient points" do
    user = FactoryGirl.build(:user)
    reward = FactoryGirl.create(:reward)
    Reward.sufficient_points(user).should have(0).items
  end

  it "should show rewards if the user has sufficient points" do
    user = FactoryGirl.create(:user)
    point = FactoryGirl.create(:point, :to_user_id => user.id)
    reward = FactoryGirl.create(:reward)
    Reward.sufficient_points(user).should have(1).items
  end

  context "quantity" do
    it "should only show rewards which have quantities remaining" do
      user = FactoryGirl.build(:user)
      reward = FactoryGirl.create(:reward, :quantity_remaining => 0)
      Reward.available.should have(0).items
    end

    it "should not show rewards where quantity is not remaining" do
      user = FactoryGirl.create(:user)
      reward = FactoryGirl.create(:reward)
      Reward.available.should have(1).items
    end
  end

  it "should show rewards in order" do
    user = FactoryGirl.create(:user)
    reward1 = FactoryGirl.create(:reward)
    reward2 = FactoryGirl.create(:reward)
    rewards = [ reward2, reward1 ]
    Reward.recent.load.should == rewards
  end

  it "should not show rewards out of order" do
    user = FactoryGirl.create(:user)
    reward1 = FactoryGirl.create(:reward)
    reward2 = FactoryGirl.create(:reward)
    rewards = [ reward1, reward2 ]
    Reward.recent.load.should_not == rewards
  end
end

