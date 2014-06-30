class FollowTest < DoGood::TestCase
  test "block" do
    @follow = FactoryGirl.create(:follow)
    refute @follow.blocked
    @follow.block!
    @follow.reload
    assert @follow.blocked
  end

  test "send notification for user" do
    stub(NotifierWorker).perform_async { true }
    @followable = FactoryGirl.create(:user)
    @follower = FactoryGirl.create(:user)
    Follow.send_notification(@followable, @follower)
    message = "#{@follower.full_name} followed you"
    url = "dogood://users/#{@follower.id}"
    assert_received(NotifierWorker) { |o| o.perform_async(message, @followable.id, { url: url }) }
  end

  test "send notification for good" do
    stub(NotifierWorker).perform_async { true }
    @followable = FactoryGirl.create(:good)
    @follower = FactoryGirl.create(:user)
    Follow.send_notification(@followable, @follower)
    message = "#{@follower.full_name} followed your good post"
    url = "dogood://users/#{@follower.id}"
    assert_received(NotifierWorker) { |o| o.perform_async(message, @followable.user_id, { url: url }) }
  end
end
