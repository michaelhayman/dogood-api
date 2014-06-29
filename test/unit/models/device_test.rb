class DeviceTokenTest < DoGood::TestCase
  def setup
    super
    @device = FactoryGirl.build(:device)
  end

  test "must have a token" do
    @device.token = nil
    refute @device.valid?
  end

  test "must have a provider" do
    @device.provider = nil
    refute @device.valid?
  end

  test "tokens for a particular user" do
    @device.save
    assert_equal [ @device.token ], Device.tokens_for(@device.user_id)
  end
end
