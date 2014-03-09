require 'test_helper'

class Users::CurrentUserSerializerTest < DoGood::TestCase
  def expected_hash
    {
      users: {
        id: @user.id,
        full_name: @user.full_name,
        location: @user.location,
        biography: @user.biography,
        points: @user.points,
        avatar_url: @user.avatar_url,
        phone: @user.phone,
        twitter_id: @user.twitter_id,
        facebook_id: @user.facebook_id
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

    @serializer = Users::CurrentUserSerializer.new @user, root: "users"
  end

  test "json for api" do
    assert_equal expected_hash.to_json, @serializer.to_json
  end

  test "json for api with message" do
    @user.message = "Well hello there."
    assert_equal expected_hash_with_message.to_json, @serializer.to_json
  end
end

