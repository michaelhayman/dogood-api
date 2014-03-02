require 'test_helper'

class VotesControllerTest < DoGood::ActionControllerTestCase
  tests VotesController

  context "create" do
    def setup
      @user = FactoryGirl.create(:user)
      sign_in @user

      @good = FactoryGirl.create(:good)
    end

    test "route" do
      assert_routing( {
        path: '/votes',
        method: :post
      }, {
        controller: "votes",
        action: "create",
      })
    end

    test "should not allow access if the user is not authenticated" do
      sign_out @user

      post :create, {
        format: :json,
        vote: {
          voteable_id: @good.id,
          voteable_type: "Good"
        }
      }
      assert_response Dapi::Constants::STATUS_CODES[:unauthorized]
    end

    test "should not allow no parameters to be passed" do
      sign_in @user
      post :create, {
        format: :json
      }
      assert_response Dapi::Constants::STATUS_CODES[:bad_object]
    end

    test "should be successful for an authenticated user & fully-populated vote" do
      sign_in @user

      assert 0, @good.votes

      post :create, {
        format: :json,
        vote: {
          voteable_id: @good.id,
          voteable_type: "Good"
        }
      }
      assert_response :success
      assert 1, @good.votes
    end

    test "users can only vote once, and fail silently otherwise" do
      @good = FactoryGirl.create(:good)
      sign_in @user

      assert 0, @good.votes

      @good.liked_by @user

      assert 1, @good.votes

      post :create, {
        format: :json,
        vote: {
          voteable_id: @good.id,
          voteable_type: "Good"
        }
      }
      json = jsonify(response)

      assert_response :success
      assert 1, @good.votes
    end

    test "vote should not succeed on a user's own good" do
      @good = FactoryGirl.create(:good, :user => @user)
      sign_in @user

      assert 0, @good.votes

      post :create, {
        format: :json,
        vote: {
          voteable_id: @good.id,
          voteable_type: "Good"
        }
      }

      assert_response :error
      assert 0, @good.votes
    end
  end

  context "remove" do
    def setup
      @user = FactoryGirl.create(:user)
      sign_in @user

      @good = FactoryGirl.create(:good)
    end

    test "route" do
      assert_routing( {
        path: '/votes/remove',
        method: :delete
      }, {
        controller: "votes",
        action: "remove"
      })
    end
  end
end

