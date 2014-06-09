class GoodDecoratorTest < DoGood::TestCase
  def setup
    super

    @good = FactoryGirl.create(:good)
    @good = GoodDecorator.decorate(@good)
    @user = FactoryGirl.create(:user)
    stub(@good.helpers).dg_user { @user.object }
    stub(@good.helpers).good_voted_on? { true }

    # these shouldn't be stubbed, since now
    # they don't test anything
    stub(@good).current_user_commented { true }
    stub(@good).current_user_voted { true }
    stub(@good).current_user_followed { false }
  end

  test "current_user_commented" do
    assert @good.current_user_commented
  end

  test "current_user_voted" do
    assert @good.current_user_voted
  end

  test "current_user_followed" do
    refute @good.current_user_followed
  end

  test "evidence" do
    assert_equal @good.evidence, @good.object.evidence.url
  end

  test "votes_count" do
    assert_equal @good.votes_count, @good.cached_votes_up
  end

  test "followers_count" do
    assert_equal @good.followers_count, @good.cached_followers_count
  end

  test "comments_count" do
    assert_equal @good.comments_count, @good.cached_comments_count
  end
end

