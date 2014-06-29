class FollowTest < DoGood::TestCase
  test "block" do
    @follow = FactoryGirl.create(:follow)
    refute @follow.blocked
    @follow.block!
    @follow.reload
    assert @follow.blocked
  end

  test "send notification for good" do
    stub(SendNotification).perform { true }
    @followable = FactoryGirl.create(:user)
    @follower = FactoryGirl.create(:user)
    Follow.send_notification(@followable, @follower)
    message = "#{@follower.full_name} followed you"
    url = "dogood://users/#{@follower.id}"
    assert_received(SendNotification) { |o| o.perform(@followable.id, message, url) }
  end

  test "send notification for user" do
    stub(SendNotification).perform { true }
    @followable = FactoryGirl.create(:good)
    @follower = FactoryGirl.create(:user)
    Follow.send_notification(@followable, @follower)
    message = "#{@follower.full_name} followed your good post"
    url = "dogood://users/#{@follower.id}"
    assert_received(SendNotification) { |o| o.perform(@followable.user_id, message, url) }
  end
end
