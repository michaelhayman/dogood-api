require 'test_helper'

class RewardsControllerTest < DoGood::ActionControllerTestCase
  tests RewardsController

  context "index" do
    test "route" do
      assert_routing '/rewards', {
        controller: "rewards",
        action: "index"
      }
    end

    test "index" do
      @reward = FactoryGirl.create(:reward)
      get :index, {
        format: :json,
        page: ""
      }

      assert_response :success
    end

    test "should return rewards matching the given ids" do
      @reward = FactoryGirl.create(:reward)
      @reward_2 = FactoryGirl.create(:reward)

      get :index, {
        format: :json
      }

      json = jsonify(response)
      assert_equal @reward.id, json.traverse(:rewards, 0, :id)
      assert_equal @reward_2.id, json.traverse(:rewards, 1, :id)
    end
  end

  context "highlights" do
    test "route" do
      assert_routing '/rewards/highlights', {
        controller: "rewards",
        action: "highlights"
      }
    end

    test "unauthorized if not logged in" do
      get :highlights, {
        format: :json
      }
      json = jsonify(response)
      assert_response :unauthorized
    end

    test "highlights" do
      @user = FactoryGirl.create(:user)
      @reward = FactoryGirl.create(:reward)
      sign_in @user

      get :highlights, {
        format: :json,
        page: ""
      }

      assert_response :success
    end


    test "should return highlights for the current user" do
      @reward = FactoryGirl.create(:reward, cost: 499)
      @reward_2 = FactoryGirl.create(:reward, cost: 800)

      @user = FactoryGirl.create(:user)
      sign_in @user

      add_points(@user)

      get :highlights, {
        format: :json
      }

      json = jsonify(response)
      assert_equal @reward.id, json.traverse(:rewards, 0, :id)
    end
  end

  context "claimed" do
    test "route" do
      assert_routing '/rewards/claimed', {
        controller: "rewards",
        action: "claimed"
      }
    end

    test "unauthorized if not logged in" do
      get :claimed, {
        format: :json
      }
      json = jsonify(response)
      assert_response :unauthorized
    end

    test "should return claimed rewards for the current user" do
      @user = FactoryGirl.create(:user)
      @reward = FactoryGirl.create(:claimed_reward, :user => @user)
      @reward_2 = FactoryGirl.create(:claimed_reward, :user => @user)
      sign_in @user

      get :claimed, {
        format: :json
      }

      json = jsonify(response)
      assert_equal @reward_2.reward_id, json.traverse(:rewards, 0, :id)
    end
  end

  context "create" do
    test "route" do
      assert_routing( {
        path: '/rewards',
        method: :post
      }, {
        controller: "rewards",
        action: "create",
      })
    end
  end

  xcontext "destroy" do
  end

  context "claim" do
    test "should route correctly" do
      assert_routing( {
        path: '/rewards/claim',
        method: :post
      }, {
        controller: "rewards",
        action: "claim",
      })
    end

    test "should be unauthorized if not logged in" do
      get :claimed, {
        format: :json
      }
      json = jsonify(response)
      assert_response :unauthorized
    end

    context "authenticated" do
      def setup
        super
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      test "should be in error with no params" do
        post :claim, {
          format: :json
        }

        assert_response :unprocessable_entity
      end

      test "should be in error with insufficient points" do
        @reward = FactoryGirl.create(:reward)

        post :claim, {
          format: :json,
          reward: {
            id: @reward.id
          }
        }

        assert_response :error
      end

      test "should be in error with wrong reward identifier" do
        post :claim, {
          format: :json,
          reward: {
            id: 23082038
          }
        }
        assert_response :error
      end

      test "should be in error with unavailable id" do
        @reward = FactoryGirl.create(:reward, :unavailable)
        add_points(@user)

        post :claim, {
          format: :json,
          reward: {
            id: @reward.id
          }
        }
        json = jsonify(response)
        p json
        assert_response :error
        assert_equal "Reward no longer available.", json.traverse(:errors, :messages, 0)
      end

      test "should claim with sufficient points & a chosen reward" do
        # stub(Good).just_created_by { false }

        @reward = FactoryGirl.create(:reward)
        add_points(@user)

        post :claim, {
          format: :json,
          reward: {
            id: @reward.id
          }
        }

        assert_response :success
        assert_equal 1, Reward.all.count

        @created_reward = @user.rewards.first
        assert_equal @created_reward.title, @reward.title
      end
    end
  end

private
    def add_points(user)
      Point.record_points("Good", 1, "Post", user.id, from_user_id = nil, 10000)
    end
end

