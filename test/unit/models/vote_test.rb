require 'test_helper'

class VoteTest < DoGood::TestCase
  def setup
    @good = FactoryGirl.create(:good)
    @user = FactoryGirl.create(:user)
  end

  context "validations" do
    test "default is valid" do
      build_vote.valid?
    end
  end

  context "queries" do
    test "should return 10 votes" do
      10.times do
        build_vote
      end
      assert_equal 10, Vote.count
    end
  end

  def build_vote
    FactoryGirl.create(:vote, :good_like, voter_id: @user.id, votable_id: @good.id)
  end
end
