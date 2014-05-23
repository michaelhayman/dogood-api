require 'test_helper'

class UserDecoratorTest < DoGood::TestCase
  def setup
    super

    @user = FactoryGirl.create(:user).decorate
  end

  test "avatar_url" do
    assert_equal "", @user.avatar_url
    # assert_equal @user.object.avatar.url, @user.avatar_url
  end

  test "followers_count" do
    @tony = FactoryGirl.create(:user, :tony)
    assert_equal 0, @user.followers_count
    @tony.follow @user.object
    assert_equal 1, @user.followers_count
  end

  # since
  test "following_count" do
    @tony = FactoryGirl.create(:user, :tony)
    assert_equal 0, @user.following_count
    @user.follow @tony
    assert_equal 1, @user.following_count
  end

  test "liked_goods_count" do
    @good = FactoryGirl.create(:good, :user => @user)
    @good_2 = FactoryGirl.create(:good)
    assert_equal 0, @user.liked_goods_count
    @good_2.liked_by @user
    assert_equal 1, @user.liked_goods_count
  end

  test "followed_goods_count" do
    @good = FactoryGirl.create(:good)
    @user.follow @good
    assert_equal 1, @user.followed_goods_count
    @user_good = FactoryGirl.create(:good, :user => @user)
    assert_equal 1, @user.followed_goods_count
  end

  test "help_wanted_goods_count" do
    @good = FactoryGirl.create(:good).decorate
    assert_equal 1, @good.user.help_wanted_by_user_goods_count
  end

  test "nominations_for_goods_count" do
    @user = FactoryGirl.create(:user).decorate
    @nominee = FactoryGirl.create(:nominee, user: @user.object)
    @good = FactoryGirl.create(:good, :done, nominee: @nominee)
    assert_equal 1, @user.nominations_for_user_goods_count
  end

  test "nominations_by_goods_count" do
    @good = FactoryGirl.create(:good, :done).decorate
    assert_equal 1, @good.user.nominations_by_user_goods_count
  end

  def teardown
    super

    @user.destroy
  end
end

