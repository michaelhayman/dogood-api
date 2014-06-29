class VotesControllerTest < DoGood::ActionControllerTestCase
  tests VotesController

  def setup
    @user = FactoryGirl.create(:user)
    sign_in @user

    @good = FactoryGirl.create(:good)
    @good_done = FactoryGirl.create(:good, :done)
  end

  test "creating vote route" do
    assert_routing( {
      path: '/votes',
      method: :post
    }, {
      controller: "votes",
      action: "create",
    })
  end

  test "creatin vote should not be allowed if the user is not authenticated" do
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

  test "casting vote by passing no parameters should fail" do
    post :create, {
      format: :json
    }
    assert_response :unprocessable_entity
  end

  test "casting fully populated vote on help wanted good" do
    assert_equal 0, @good.cached_votes_up

    add_valid_vote(@good)

    assert_response :success
    assert_equal @good.id, voted_good(@good).id
    assert_equal 1, voted_good(@good).cached_votes_up
  end

  test "casting fully populated vote on 'done' good" do
    assert_equal 0, @good_done.nominee.user.points
    assert_equal 0, @good_done.cached_votes_up

    add_valid_vote(@good_done)

    assert_response :success
    assert_equal 1, voted_good(@good_done).cached_votes_up
    assert_equal Vote::VOTE_POINTS, voted_good(@good_done).nominee.user.points
    assert_equal 0, @user.points
  end

  test "casting vote should succeed on a user's own good" do
    @good = FactoryGirl.create(:good, user: @user)

    assert_equal 0, @good.cached_votes_up

    add_valid_vote(@good)

    assert_equal 1, voted_good(@good).cached_votes_up
  end

  test "casting a re-vote should silently fail to increment votes" do
    assert_equal 0, @good.cached_votes_up

    add_valid_vote(@good)
    add_valid_vote(@good)
    assert_response :success

    assert_equal 1, voted_good(@good).cached_votes_up
  end

  test "casting vote fails when database fails" do
    any_instance_of(Good) do |klass|
        stub(klass).liked_by { false }
    end

    add_valid_vote(@good)

    assert_response :bad_request
    assert_equal 0, @good.votes_for.count
  end

  test "remove route" do
    assert_routing( {
      path: '/votes/1',
      method: :delete
    }, {
      controller: "votes",
      id: "1",
      action: "destroy"
    })
  end

  test "passing no parameters should fail to remove" do
    delete :destroy, {
      format: :json,
      id: 1
    }
    assert_response :unprocessable_entity
  end

  test "removing vote on a 'help wanted' good" do
    assert_equal 0, @good.cached_votes_up

    @good.liked_by @user
    assert_equal 1, @good.cached_votes_up

    remove_valid_vote(@good)

    assert_response :success
    assert_equal 0, voted_good(@good).cached_votes_up
  end

  test "removing vote on a 'done' good" do
    assert_equal 0, @good_done.nominee.user.points
    assert_equal 0, @good_done.cached_votes_up

    add_valid_vote(@good_done)

    assert_equal 1, voted_good(@good_done).cached_votes_up
    assert_equal Vote::VOTE_POINTS, voted_good(@good_done).nominee.user.points

    remove_valid_vote(@good_done)

    assert_response :success
    assert_equal 0, voted_good(@good_done).cached_votes_up
    assert_equal 0, voted_good(@good_done).nominee.user.points
    assert_equal 0, @user.points
  end

  test "removing vote fails without valid parameters" do
    @good.liked_by @user
    assert_equal 1, @good.cached_votes_up

    any_instance_of(Good) do |klass|
      stub(klass).unliked_by { false }
    end

    remove_valid_vote(@good)

    assert_response :bad_request
    assert_equal 1, @good.cached_votes_up
  end

  test "removing vote fails when database fails" do
    any_instance_of(Good) do |klass|
      stub(klass).unliked_by { false }
    end

    remove_valid_vote(@good)

    assert_response :bad_request
    assert_equal 0, @good.cached_votes_up
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

  def voted_good(object)
    Good.find(object.id)
  end
end

