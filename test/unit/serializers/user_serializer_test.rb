require 'test_helper'

class UserSerializerTest < DoGood::TestCase
  def expected_hash
    {
      users: {
        id: @user.id,
        avatar_url: @user.avatar_url,
        full_name: @user.full_name
      }
    }
  end

  def expected_hash_with_message
    {
      users: {
        message: @user.message
      }
    }
  end

  def setup
    super
    @user = FactoryGirl.create(:user).decorate

    @serializer = UserSerializer.new @user, root: "users"
  end

  test "json for api" do
    assert_equal expected_hash.to_json, @serializer.to_json
  end

  test "json for api with message" do
    @user.message = "Well hello there."
    assert_equal expected_hash_with_message.to_json, @serializer.to_json
  end
end

