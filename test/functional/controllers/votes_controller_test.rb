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

      test "should work for authenticated user & fully-populated vote" do
        sign_in @user

        assert 0, @user.points
        assert 0, @good.votes.count

        add_valid_vote(@good)

        assert_response :success
        assert 1, @good.votes
        assert 10, @user.points
      end

      test "users can only vote once, and fail silently otherwise" do
        @good = FactoryGirl.create(:good)
        sign_in @user

        assert 0, @good.votes.count

        @good.liked_by @user

        assert 1, @good.votes.count

        add_valid_vote(@good)

        json = jsonify(response)

        assert_response :success
        assert 1, @good.votes.count
      end

      test "vote should succeed on a user's own good" do
        @good = FactoryGirl.create(:good, :user => @user)
        sign_in @user

        assert 0, @good.votes.count

        add_valid_vote(@good)

        assert 1, @good.votes
      end

      test "a re-vote should silently fail to increment votes" do
        sign_in @user

        assert 0, @good.votes.count

        add_valid_vote(@good)

        assert 0, @good.votes.count
      end

      test "fails when database fails" do
        any_instance_of(Good) do |klass|
            stub(klass).liked_by { false }
        end

        add_valid_vote(@good)

        assert_response :bad_request
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
        assert 0, @user.points
        @good.liked_by @user

        remove_valid_vote(@good)

        assert_response :success
        assert 0, @good.votes.count
        assert -10, @user.points
      end

      test "fails without valid parameters" do
        @good.liked_by @user
        assert 1, @good.votes.count
        stub(@good).unliked_by { false }

        remove_valid_vote(@good)

        assert_response :success
        assert 0, @good.votes.count
      end

      test "fails when database fails" do
        any_instance_of(Good) do |klass|
            stub(klass).unliked_by { false }
        end

        remove_valid_vote(@good)

        assert_response :bad_request
        assert 0, @good.votes.count
      end
    end
  end

  private
    def add_valid_vote(object)
      post :create, {
        format: :json,
        vote: {
          votable_id: object.id,
          votable_type: "Good"
        }
      }
    end

    def remove_valid_vote(object)
      delete :destroy, {
        format: :json,
        id: object.id,
        vote: {
          votable_id: object.id,
          votable_type: "Good"
        }
      }
    end
end

