require 'test_helper'

class FollowTest < DoGood::TestCase
  test "block" do
    @follow = FactoryGirl.create(:follow)
    refute @follow.blocked
    @follow.block!
    @follow.reload
    assert @follow.blocked
  end
end
