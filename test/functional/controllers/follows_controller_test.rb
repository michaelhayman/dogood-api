require 'test_helper'

class FollowsControllerTest < DoGood::ActionControllerTestCase
  tests FollowsController

  def setup
    @user = FactoryGirl.create(:user)
    sign_in @user

    @good = FactoryGirl.create(:good)
  end

  context "create" do
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

    context "authenticated" do
      test "do not allow empty parameters" do
        sign_in @user
        post :create, {
          format: :json
        }
        assert_response :unprocessable_entity
      end

      test "follow with valid parameters should succeed" do
        sign_in @user

        assert 0, @good.followers

        post :create, {
          format: :json,
          follow: {
            followable_id: @good.id,
            followable_type: "Good"
          }
        }
        json = jsonify(response)
        p json
        assert_response :success
        assert 1, @good.followers
      end

      test "following something already followed should fail" do
        sign_in @user

        @user.follow @good

        post :create, {
          format: :json,
          follow: {
            followable_id: @good.id,
            followable_type: "Good"
          }
        }
        json = jsonify(response)
        assert_response :internal_server_error
        assert 0, @good.followers
      end
    end
  end

  context "remove" do
    test "route" do
      assert_routing( {
        path: '/follows/remove',
        method: :delete
      }, {
        controller: "follows",
        action: "remove"
      })
    end

    test "prevent access if unauthenticated" do
      sign_out @user

      post :remove, {
        format: :json,
        vote: {
          voteable_id: @good.id,
          voteable_type: "Good"
        }
      }
      assert_response :unauthorized
    end

    context "authenticated" do
      test "do not allow empty parameters" do
        sign_in @user
        post :remove, {
          format: :json
        }
        assert_response :unprocessable_entity
      end

      test "unfollow with valid parameters should succeed" do
        sign_in @user

        @user.follow @good

        assert 1, @good.followers

        post :remove, {
          format: :json,
          follow: {
            followable_id: @good.id,
            followable_type: "Good"
          }
        }
        json = jsonify(response)
        assert_response :success
        assert 0, @good.followers
      end

      test "unfollowing something not already followed should fail" do
        sign_in @user

        post :remove, {
          format: :json,
          follow: {
            followable_id: @good.id,
            followable_type: "Good"
          }
        }
        json = jsonify(response)
        assert_response :internal_server_error
        assert 0, @good.followers
      end
    end
  end

  def teardown
    sign_out @user
  end
end

