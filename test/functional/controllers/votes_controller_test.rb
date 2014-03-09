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
          votable_id: @good.id,
          votable_type: "Good"
        }
      }
      assert_response :unauthorized
    end

    context "for authenticated users" do
      test "passing no parameters should fail" do
        sign_in @user
        post :create, {
          format: :json
        }
        assert_response :unprocessable_entity
      end

      test "should be authenticated user & fully-populated vote" do
        sign_in @user

        assert 0, @good.votes.count

        post :create, {
          format: :json,
          vote: {
            votable_id: @good.id,
            votable_type: "Good"
          }
        }
        assert_response :success
        assert 1, @good.votes
      end

      test "users can only vote once, and fail silently otherwise" do
        @good = FactoryGirl.create(:good)
        sign_in @user

        assert 0, @good.votes.count

        @good.liked_by @user

        assert 1, @good.votes.count

        post :create, {
          format: :json,
          vote: {
            votable_id: @good.id,
            votable_type: "Good"
          }
        }
        json = jsonify(response)

        assert_response :success
        assert 1, @good.votes.count
      end

      test "vote should not succeed on a user's own good" do
        @good = FactoryGirl.create(:good, :user => @user)
        sign_in @user

        assert 0, @good.votes.count

        post :create, {
          format: :json,
          vote: {
            votable_id: @good.id,
            votable_type: "Good"
          }
        }

        assert_response :error
        assert 0, @good.votes
      end

      test "a re-vote should silently fail to increment votes" do
        sign_in @user

        assert 0, @good.votes.count

        post :create, {
          format: :json,
          vote: {
            votable_id: @good.id,
            votable_type: "Good"
          }
        }

        assert 0, @good.votes.count
      end
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
        path: '/votes/1',
        method: :delete
      }, {
        controller: "votes",
        id: "1",
        action: "destroy"
      })
    end

    context "for an authenticated user" do
      test "succeeds with valid parameters" do
        sign_in @user

        assert 0, @good.votes.count
        @good.liked_by @user

        delete :destroy, {
          format: :json,
          id: @good.id,
          vote: {
            votable_id: @good.id,
            votable_type: "Good"
          }
        }
        assert_response :success
        assert 0, @good.votes.count
      end

      test "fails without valid parameters" do
        sign_in @user

        @good.liked_by @user
        assert 1, @good.votes.count
        stub(@good).unliked_by { false }

        delete :destroy, {
          format: :json,
          id: @good.id,
          vote: {
            votable_id: @good.id,
            votable_type: "Good"
          }
        }
        assert_response :success
        assert 0, @good.votes.count
      end
    end
  end
end

