require 'test_helper'

class VoteTest < DoGood::TestCase
  def setup
    @good = FactoryGirl.create(:good)
    @user = FactoryGirl.create(:user)
  end

  test "default is valid" do
    build_vote.valid?
  end

  test "should return 10 votes" do
    10.times do
      build_vote
    end
    assert_equal 10, Vote.count
  end

  def build_vote
    FactoryGirl.create(:vote, :good_like, voter_id: @user.id, votable_id: @good.id)
  end
end
