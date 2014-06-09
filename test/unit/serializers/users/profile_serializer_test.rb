class Users::ProfileSerializerTest < DoGood::TestCase
  def expected_hash
    {
      users: {
        id: @user.id,
        avatar_url: @user.avatar_url,
        full_name: @user.full_name,
        location: @user.location,
        current_user_following: @user.current_user_following,
        followers_count: @user.followers_count,
        following_count: @user.following_count,
        voted_goods_count: @user.voted_goods_count,
        rank: @user.rank,
        followed_goods_count: @user.followed_goods_count,
        nominations_for_user_goods_count: @user.nominations_for_user_goods_count,
        nominations_by_user_goods_count: @user.nominations_by_user_goods_count,
        help_wanted_by_user_goods_count: @user.help_wanted_by_user_goods_count
      }
    }
  end

  def setup
    super
    @user = FactoryGirl.create(:user).decorate

    stub(@user.helpers).dg_user { @user.object }
    stub(@user.helpers.dg_user).user_followed? { true }

    stub(@user.object).following_users_count { 5 }

    @serializer = Users::ProfileSerializer.new @user, root: "users"
  end

  test "json for api" do
    assert_equal expected_hash.to_json, @serializer.to_json
  end
end

