class RewardDecoratorTest < DoGood::TestCase
  def setup
    super

    @reward = FactoryGirl.create(:reward).decorate
  end

  test "teaser" do
    assert_equal @reward.teaser, @reward.object.teaser.url
  end

  test "has sufficient points" do
    @user = FactoryGirl.create(:user).decorate
    stub(@reward.helpers).dg_user { @user.object }
    stub(@reward.helpers).logged_in? { true }
    @user.add_points(6000, category: "Bonus")
    assert @reward.within_budget
  end

  test "does not have sufficient points" do
    @user = FactoryGirl.create(:user).decorate
    stub(@reward.helpers).dg_user { @user.object }
    stub(@reward.helpers).logged_in? { true }
    refute @reward.within_budget
  end

  test "not within budget if user is not signed in" do
    @user = NullUser.new
    stub(@reward.helpers).dg_user { @user }
    stub(@reward.helpers).logged_in? { false }
    refute @reward.within_budget
  end
end

