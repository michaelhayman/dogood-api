require 'test_helper'

class GoodDecoratorTest < DoGood::TestCase
  def setup
    super

    @good = FactoryGirl.create(:good)
    @good = GoodDecorator.decorate(@good)
    @user = FactoryGirl.create(:user)
    stub(@good.helpers).dg_user { @user.object }
    stub(@good.helpers).good_liked? { true }

    # these shouldn't be stubbed, since now
    # they don't test anything
    stub(@good).current_user_commented { true }
    stub(@good).current_user_liked { true }
    stub(@good).current_user_regooded { false }
  end

  context "current_user_commented" do
    test "set" do
      assert @good.current_user_commented
    end
  end

  context "current_user_liked" do
    test "set" do
      assert @good.current_user_liked
    end
  end

  context "current_user_regooded" do
    test "set" do
      refute @good.current_user_regooded
    end
  end

  context "evidence" do
    test "set correctly" do
      assert_equal @good.evidence, @good.object.evidence.url
    end
  end

  context "likes_count" do
    test "set correctly" do
      assert_equal @good.likes_count, @good.cached_votes_up
    end
  end

  context "regoods_count" do
    test "set correctly" do
      assert_equal @good.regoods_count, @good.follows_count
    end
  end
end

