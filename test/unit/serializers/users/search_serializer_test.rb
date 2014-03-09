require 'test_helper'

class Users::SearchSerializerTest < DoGood::TestCase
  def expected_hash
    {
      users: {
        id: @user.id,
        full_name: @user.full_name,
        avatar_url: @user.avatar_url,
        location: @user.location,
        current_user_following: @user.current_user_following
      }
    }
  end

  def setup
    super
    @user = FactoryGirl.create(:user).decorate
    stub(@user).current_user_following { true }

    @serializer = Users::SearchSerializer.new @user, root: "users"
  end

  test "json for api" do
    assert_equal expected_hash.to_json, @serializer.to_json
  end
end

