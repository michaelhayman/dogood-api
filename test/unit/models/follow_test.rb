require 'test_helper'

class FollowTest < DoGood::TestCase
  context "has validations" do
  end

  # This is implemented by each controller it seems
  xtest "returns followings for a given type and instance" do
    @user = FactoryGirl.create(:user)
    @good = FactoryGirl.create(:good)
    @user.follow @good
    Follow.following("Good", @good.id).should have(1).items
  end

  test "block" do
    @follow = FactoryGirl.create(:follow)
    refute @follow.blocked
    @follow.block!
    assert @follow.blocked
  end
end
