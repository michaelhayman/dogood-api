class FollowsControllerTest < DoGood::ActionControllerTestCase
  tests FollowsController

  def setup
    super
    @user = FactoryGirl.create(:user)
    sign_in @user

    @good = FactoryGirl.create(:good)
  end

  class FollowsControllerTest::Create < FollowsControllerTest
    test "route" do
      assert_routing( {
        path: '/follows',
        method: :post
      }, {
        controller: "follows",
        action: "create",
      })
    end

    test "prevent access if unauthenticated" do
      sign_out @user

      post :create, {
        format: :json,
        vote: {
          voteable_id: @good.id,
          voteable_type: "Good"
        }
      }
      assert_response :unauthorized
    end

    test "do not allow empty parameters" do
      post :create, {
        format: :json
      }
      assert_response :unprocessable_entity
    end

    test "follow with valid parameters should succeed" do
      assert_empty @good.followers

      post :create, {
        format: :json,
        follow: {
          followable_id: @good.id,
          followable_type: "Good"
        }
      }
      json = jsonify(response)
      assert_response :success
      assert_equal [ @user ], @good.followers
    end

    test "following something already followed should fail" do
      @user.follow @good

      post :create, {
        format: :json,
        follow: {
          followable_id: @good.id,
          followable_type: "Good"
        }
      }
      json = jsonify(response)
      assert_response :unprocessable_entity
      assert_equal [ @user ], @good.followers
    end

    test "database error" do
      any_instance_of(User) do |klass|
          stub(klass).follow { false }
      end

      post :create, {
        format: :json,
        follow: {
          followable_id: @good.id,
          followable_type: "Good"
        }
      }
      json = jsonify(response)
      assert_response :internal_server_error
      assert_empty @good.followers
    end
  end

  class FollowsControllerTest::Destroy < FollowsControllerTest
    test "route" do
      assert_routing( {
        path: '/follows/1',
        method: :delete
      }, {
        controller: "follows",
        action: "destroy",
        id: "1"
      })
    end

    test "prevent access if unauthenticated" do
      sign_out @user

      delete :destroy, {
        format: :json,
        id: @good.id,
        vote: {
          voteable_id: @good.id,
          voteable_type: "Good"
        }
      }
      assert_response :unauthorized
    end

    test "do not allow empty parameters" do
      delete :destroy, {
        id: @good.id,
        format: :json
      }
      assert_response :unprocessable_entity
    end

    test "unfollow with valid parameters should succeed" do
      @user.follow @good

      assert_equal [ @user ], @good.followers

      delete :destroy, {
        format: :json,
        id: @good.id,
        follow: {
          followable_id: @good.id,
          followable_type: "Good"
        }
      }
      json = jsonify(response)
      assert_response :success
      assert_empty @good.followers
    end

    test "unfollowing something not already followed should fail" do
      delete :destroy, {
        format: :json,
        id: @good.id,
        follow: {
          followable_id: @good.id,
          followable_type: "Good"
        }
      }
      json = jsonify(response)
      assert_response :internal_server_error
      assert_empty @good.followers
    end
  end
end

