require 'test_helper'

class RewardTest < DoGood::TestCase
  context "has validations" do
    test "should be valid" do
      assert FactoryGirl.build(:reward).valid?
    end

    test "should be not be valid without a cost" do
      refute FactoryGirl.build(:reward, cost: "").valid?
    end

    test "should be not be valid without a title" do
      refute FactoryGirl.build(:reward, title: "").valid?
    end

    test "should be not be valid without a subtitle" do
      refute FactoryGirl.build(:reward, subtitle: "").valid?
    end

    test "should be not be valid without a quantity" do
      refute FactoryGirl.build(:reward, quantity: "").valid?
    end

    test "should be not be valid without a quantity remaining" do
      refute FactoryGirl.build(:reward, quantity_remaining: "").valid?
    end
  end

  test "should show no rewards if the user has insufficient points" do
    user = FactoryGirl.build(:user)
    reward = FactoryGirl.create(:reward)
    assert_equal 0, Reward.sufficient_points(user).count
  end

  test "should show rewards if the user has sufficient points" do
    user = FactoryGirl.create(:user)
    user.add_points(10000, category: 'Bonus')
    reward = FactoryGirl.create(:reward)
    assert_equal 1, Reward.sufficient_points(user).count
  end

  context "quantity" do
    test "should only show rewards which have quantities remaining" do
      user = FactoryGirl.build(:user)
      reward = FactoryGirl.create(:reward, quantity_remaining: 0)
      assert_equal 0, Reward.available.count
    end

    test "should not show rewards where quantity is not remaining" do
      user = FactoryGirl.create(:user)
      reward = FactoryGirl.create(:reward)
      assert_equal 1, Reward.available.count
    end
  end

  test "should show rewards in order" do
    user = FactoryGirl.create(:user)
    reward1 = FactoryGirl.create(:reward)
    reward2 = FactoryGirl.create(:reward)
    rewards = [ reward2, reward1 ]
    assert_equal rewards, Reward.recent.load
  end

  test "should not show rewards out of order" do
    user = FactoryGirl.create(:user)
    reward1 = FactoryGirl.create(:reward)
    reward2 = FactoryGirl.create(:reward)
    rewards = [ reward1, reward2 ]
    refute_equal rewards, Reward.recent.load
  end

  test "should block posting for a user who just created a reward" do
    FactoryGirl.create(:reward, user_id: 11)
    assert Reward.just_created_by(11)
  end
end
