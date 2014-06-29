class NotificationTest < DoGood::TestCase
  test "send url" do
    stub(APN).push { true }
    assert Notification.send_url("token", "message", "url")
  end
end

