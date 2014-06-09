class RewardsControllerTest < DoGood::ActionControllerTestCase
  tests RewardsController

  BASE_POINTS = 10000

  test "index route" do
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

  test "index should return rewards matching the given ids" do
    @reward = FactoryGirl.create(:reward)
    @reward_2 = FactoryGirl.create(:reward)

    get :index, {
      format: :json
    }

    json = jsonify(response)
    assert_equal @reward.id, json.traverse(:rewards, 0, :id)
    assert_equal @reward_2.id, json.traverse(:rewards, 1, :id)
  end

  test "highlights route" do
    assert_routing '/rewards/highlights', {
      controller: "rewards",
      action: "highlights"
    }
  end

  test "highlights unauthorized if not logged in" do
    get :highlights, {
      format: :json
    }
    json = jsonify(response)
    assert_response :unauthorized
  end

  test "highlights results" do
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

  test "claimed route" do
    assert_routing '/rewards/claimed', {
      controller: "rewards",
      action: "claimed"
    }
  end

  test "claimed reward unauthorized if not logged in" do
    get :claimed, {
      format: :json
    }
    json = jsonify(response)
    assert_response :unauthorized
  end

  test "should return claimed rewards for the current user" do
    @user = FactoryGirl.create(:user)
    @reward = FactoryGirl.create(:claimed_reward, user: @user)
    @reward_2 = FactoryGirl.create(:claimed_reward, user: @user)
    sign_in @user

    get :claimed, {
      format: :json
    }

    json = jsonify(response)
    assert_equal @reward_2.reward_id, json.traverse(:rewards, 0, :id)
  end

  test "create reward route" do
    assert_routing( {
      path: '/rewards',
      method: :post
    }, {
      controller: "rewards",
      action: "create",
    })
  end

  test "create should be unauthorized if not logged in" do
    post :create, {
      format: :json
    }
    json = jsonify(response)
    assert_response :unauthorized
  end

  test "create should succeed for valid params" do
    @user = FactoryGirl.create(:user)
    sign_in @user

    @reward = FactoryGirl.build(:reward)

    post :create, {
      format: :json,
      reward: {
        id: @reward.id,
        title: @reward.title,
        subtitle: @reward.subtitle,
        quantity: @reward.quantity,
        quantity_remaining: @reward.quantity_remaining,
        cost: @reward.cost
      }
    }

    assert_response :success
  end

  test "should fail for db error" do
    @user = FactoryGirl.create(:user)
    sign_in @user

    @reward = FactoryGirl.build(:reward)
    stub_save_method(Reward)

    post :create, {
      format: :json,
      reward: {
        id: @reward.id,
        title: @reward.title
      }
    }

    assert_response :internal_server_error
  end

  test "destroy route" do
    assert_routing( {
      path: '/rewards/1',
      method: :delete
    }, {
      controller: "rewards",
      action: "destroy",
      id: "1"
    })
  end

  test "claim should route correctly" do
    assert_routing( {
      path: '/rewards/claim',
      method: :post
    }, {
      controller: "rewards",
      action: "claim",
    })
  end

  test "claiming a reward should be unauthorized if not logged in" do
    get :claimed, {
      format: :json
    }
    json = jsonify(response)
    assert_response :unauthorized
  end

  class RewardsControllerTest::Claim < DoGood::ActionControllerTestCase
    def setup
      super
      @user = FactoryGirl.create(:user)
      stub(Reward).just_created_by { false }
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

      assert_response :internal_server_error
    end

    test "should be in error with wrong reward identifier" do
      post :claim, {
        format: :json,
        reward: {
          id: 23082038
        }
      }
      assert_response :internal_server_error
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

      assert_response :internal_server_error
      assert_equal "Reward no longer available.", json.traverse(:errors, :messages, 0)
    end

    test "should claim with sufficient points & a chosen reward" do
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
      assert_equal @user.points, BASE_POINTS - @reward.cost
    end

    test "should fail gracefully on db error" do
      @user = FactoryGirl.create(:user)
      sign_in @user

      @reward = FactoryGirl.create(:reward)
      add_points(@user)

      any_instance_of(ClaimedReward) do |klass|
        stub(klass).create_claim { false }
      end

      post :claim, {
        format: :json,
        reward: {
          id: @reward.id
        }
      }

      assert_response :internal_server_error
    end
    def add_points(user)
      user.add_points(BASE_POINTS, category: 'Bonus')
    end
  end

  def add_points(user)
    user.add_points(BASE_POINTS, category: 'Bonus')
  end
end

