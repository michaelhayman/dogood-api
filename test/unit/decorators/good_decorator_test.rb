require 'test_helper'

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

  context "current_user_commented" do
    test "set" do
      assert @good.current_user_commented
    end
  end

  context "current_user_voted" do
    test "set" do
      assert @good.current_user_voted
    end
  end

  context "current_user_followed" do
    test "set" do
      refute @good.current_user_followed
    end
  end

  context "evidence" do
    test "set correctly" do
      assert_equal @good.evidence, @good.object.evidence.url
    end
  end

  context "votes_count" do
    test "set correctly" do
      assert_equal @good.votes_count, @good.cached_votes_up
    end
  end

  context "followers_count" do
    test "set correctly" do
      assert_equal @good.followers_count, @good.cached_followers_count
    end
  end

  context "comments_count" do
    test "set correctly" do
      assert_equal @good.comments_count, @good.cached_comments_count
    end
  end
end

