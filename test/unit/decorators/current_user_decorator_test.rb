require 'test_helper'

class CurrentUserDecoratorTest < DoGood::TestCase
  def setup
    super

    @user = CurrentUserDecorator.decorate(FactoryGirl.create(:user))
    @user_2 = FactoryGirl.create(:user)
    @user_3 = FactoryGirl.create(:user)
    @user.follow(@user_2)

    @good = FactoryGirl.create(:good)
    @comment_1 = FactoryGirl.create(:comment, :for_good, user: @user.object, commentable_id: @good.id)
    @user.follow(@good)
    @good.upvote_from @user.object

    @good_2 = FactoryGirl.create(:good)
    @comment_2 = FactoryGirl.create(:comment, :for_good, user: @user.object, commentable_id: @good_2.id)
    @user.follow(@good_2)
    @good_2.upvote_from @user.object

    @good_3 = FactoryGirl.create(:good)

    @good_ids = [
      @good.id, @good_2.id, @good_3.id
    ]

    @user_ids = [
      @user.id, @user_2.id, @user_3.id
    ]
  end

  test "voted_good_ids should contain only the voted IDs" do
    assert_same_contents [ @good_2.id, @good.id ], @user.voted_good_ids
    assert Good.all.count > @user.voted_good_ids.count
  end

  test "good_voted_on? should be true for a voted on good" do
    assert(@user.good_voted_on?(@good), "should accept a good itself")
    assert(@user.good_voted_on?(@good.id), "should accept a good id")
  end

  test "good_voted_on? should be false for a good which isn't voted on" do
    refute(@user.good_voted_on?(@good_3), "should accept good itself")
    refute(@user.good_voted_on?(@good_3.id), "should accept a good id")
  end

  test "commented_good_ids should contain only the commented IDs" do
    assert_equal [ @good_2.id, @good.id ], @user.commented_good_ids
    assert Good.all.count > @user.commented_good_ids.count
  end

  test "good_commented? should be true for a commented good" do
      assert(@user.good_commented?(@good), "should accept a good itself")
      assert(@user.good_commented?(@good.id), "should accept a good id")
    end

  test "good_commented? should be false for a good which isn't voted on" do
    refute(@user.good_commented?(@good_3), "should accept good itself")
    refute(@user.good_commented?(@good_3.id), "should accept a good id")
  end

  test "followed_good_ids should contain only the followed IDs" do
    assert_same_contents [ @good_2.id, @good.id ], @user.followed_good_ids
    assert Good.all.count > @user.followed_good_ids.count
  end

  test "good_followed? should be true for a followed good" do
    assert(@user.good_followed?(@good), "should accept a good itself")
    assert(@user.good_followed?(@good.id), "should accept a good id")
  end

  test "should be false for a good which isn't voted on" do
    refute(@user.good_followed?(@good_3), "should accept good itself")
    refute(@user.good_followed?(@good_3.id), "should accept a good id")
  end

  test "followed_user_ids should contain only the followed IDs" do
    assert_equal [ @user_2.id ], @user.followed_user_ids
    assert User.all.count > @user.followed_user_ids.count
  end

  test "user_followed? should be true for a followed user" do
    assert(@user.user_followed?(@user_2), "should accept a user itself")
    assert(@user.user_followed?(@user_2.id), "should accept a user id")
  end

  test "should be false for a non-followed user" do
    refute(@user.user_followed?(@user_3), "should accept user itself")
    refute(@user.user_followed?(@user_3.id), "should accept a user id")
  end
end
