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

  test "send notification for vote" do
    @good = FactoryGirl.create(:good)
    @bob = FactoryGirl.create(:user)
    stub(NotifierWorker).perform_async { true }
    Vote.send_notification(@good, @bob)
    message = "#{@user.full_name} voted on your post"
    url = "dogood://goods/#{@good.id}"
    assert_received(NotifierWorker) { |o| o.perform_async(message, @good.user_id, { url: url }) }
  end
end
