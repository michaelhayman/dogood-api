require 'test_helper'

class UserDecoratorTest < DoGood::TestCase
  def setup
    super

    Fog.mock!
    # Fog.credentials_path = Rails.root.join('config/fog_credentials.yml')
    # connection = Fog::Storage.new(:provider => 'AWS')
    # connection.directories.create(:key => 'my_bucket')
    @user = FactoryGirl.create(:user)
    @user = UserDecorator.decorate(@user)
  end

  context "avatar" do
    test "avatar" do
      assert_equal "hey", @user.avatar_url
    end
  end
end

