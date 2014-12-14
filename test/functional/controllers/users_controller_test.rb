class UsersControllerTest < DoGood::ActionControllerTestCase
  tests UsersController

  class UsersControllerTest::Show < DoGood::ActionControllerTestCase
    test "route" do
      assert_routing '/users/1', {
        controller: "users",
        action: "show",
        id: "1"
      }
    end

    test "request should be successful when given correct param ID" do
      @user = FactoryGirl.create(:user, :bob)

      get :show, {
        format: :json,
        id: @user.id
      }

      json = jsonify(response)
      assert_response :success

      assert_equal @user.full_name, json.traverse(:users, :full_name)
    end
  end

  class UsersControllerTest::Search < DoGood::ActionControllerTestCase
    test "route" do
      assert_routing({
        path: '/users/search',
        method: :get
      }, {
        controller: "users",
        action: "search",
        search: "Michael"
      },
      {},
      {
        search: 'Michael'
      })
    end

    test "request should find users" do
      @bob = FactoryGirl.create(:user, :bob)
      @tony = FactoryGirl.create(:user, :tony)

      get :search, {
        format: :json,
        search: @bob.full_name
      }

      json = jsonify(response)
      assert_response :success

      assert_equal @bob.full_name, json.traverse(:users, 0, :full_name)
    end
  end

  class UsersControllerTest::SearchByEmails < DoGood::ActionControllerTestCase
    test "route" do
      assert_routing '/users/search_by_emails', {
        controller: "users",
        action: "search_by_emails"
      }
    end

    test "unauthorized if not logged in" do
      post :search_by_emails, {
        format: :json
      }
      json = jsonify(response)
      assert_response :unauthorized
    end

    test "invalid if no emails param" do
      @user = FactoryGirl.create(:user)

      sign_in @user

      get :search_by_emails, {
        format: :json
      }
      json = jsonify(response)
      assert_response :unprocessable_entity
    end

    test "request should be successful given the correct params" do
      @user = FactoryGirl.create(:user)
      @bob = FactoryGirl.create(:user, :bob)
      @tony = FactoryGirl.create(:user, :tony)

      sign_in @user

      emails = [ @bob.email, @tony.email ]

      get :search_by_emails, {
        format: :json,
        emails: emails
      }

      json = HashWithIndifferentAccess.new(JSON.load(response.body))
      assert_response :success

      assert_equal 2, json.traverse(:users).count
    end
  end

  class UsersControllerTest::SearchByTwitterIDs < DoGood::ActionControllerTestCase
    test "route" do
      assert_routing '/users/search_by_twitter_ids', {
        controller: "users",
        action: "search_by_twitter_ids"
      }
    end

    test "invalid if no twitter_ids param" do
      get :search_by_twitter_ids, {
        format: :json
      }
      json = jsonify(response)
      assert_response :unprocessable_entity
    end

    test "request should be successful when given correct params" do
      @bob = FactoryGirl.create(:user, :bob)
      @tony = FactoryGirl.create(:user, :tony)

      twitters = [ @bob.twitter_id, @tony.twitter_id ]

      get :search_by_twitter_ids, {
        format: :json,
        twitter_ids: twitters
      }

      json = HashWithIndifferentAccess.new(JSON.load(response.body))
      assert_response :success

      assert_equal 2, json.traverse(:users).count
    end
  end

  class UsersControllerTest::SearchByFacebookIDs < DoGood::ActionControllerTestCase
    test "route" do
      assert_routing '/users/search_by_facebook_ids', {
        controller: "users",
        action: "search_by_facebook_ids"
      }
    end

    test "invalid if no facebook_ids param" do
      get :search_by_facebook_ids, {
        format: :json
      }
      json = jsonify(response)
      assert_response :unprocessable_entity
    end

    test "request should be successful when given correct params" do
      @bob = FactoryGirl.create(:user, :bob)
      @tony = FactoryGirl.create(:user, :tony)

      facebooks = [ @bob.facebook_id, @tony.facebook_id ]

      get :search_by_facebook_ids, {
        format: :json,
        facebook_ids: facebooks
      }
      json = jsonify(response)

      assert_response :success

      assert_equal 2, json.traverse(:users).count
    end
  end

  class UsersControllerTest::Voters < DoGood::ActionControllerTestCase
    test "route" do
      assert_routing '/users/voters', {
        controller: "users",
        action: "voters"
      }
    end

    test "request should be successful when given correct params" do
      @bob = FactoryGirl.create(:user, :bob)
      @good = FactoryGirl.create(:good)
      @good.liked_by @bob

      get :voters, {
        format: :json,
        type: "Good",
        id: @good.id
      }
      json = jsonify(response)

      assert_response :success

      assert_equal @bob.full_name, json.traverse(:users, 0, :full_name)
    end
  end

  class UsersControllerTest::Followers < DoGood::ActionControllerTestCase
    test "route" do
      assert_routing '/users/followers', {
        controller: "users",
        action: "followers"
      }
    end

    test "query goods" do
      @bob = FactoryGirl.create(:user, :bob)
      @good = FactoryGirl.create(:good)
      @bob.follow @good

      get :followers, {
        format: :json,
        type: "Good",
        id: @good.id
      }
      json = jsonify(response)

      assert_response :success

      assert_equal @bob.full_name, json.traverse(:users, 0, :full_name)
    end

    test "query users" do
      @bob = FactoryGirl.create(:user, :bob)
      @tony = FactoryGirl.create(:user, :tony)
      @bob.follow @tony

      get :followers, {
        format: :json,
        type: "User",
        id: @tony.id
      }
      json = jsonify(response)

      assert_response :success

      assert_equal @bob.full_name, json.traverse(:users, 0, :full_name)
    end
  end

  class UsersControllerTest::Following < DoGood::ActionControllerTestCase
    test "route" do
      assert_routing '/users/following', {
        controller: "users",
        action: "following"
      }
    end

    test "query" do
      @bob = FactoryGirl.create(:user, :bob)
      @tony = FactoryGirl.create(:user, :tony)
      @bob.follow @tony

      get :following, {
        format: :json,
        type: "User",
        id: @bob.id
      }
      json = jsonify(response)

      assert_response :success

      assert_equal @tony.full_name, json.traverse(:users, 0, :full_name)
    end
  end

  class UsersController::NominationsFor < DoGood::ActionControllerTestCase
    test "route" do
      assert_routing '/users/hammy/nominations_for', {
        controller: "users",
        action: "nominations_for",
        id: "hammy"
      }
    end

    test "should return goods that a user was nominated for" do
      @user = FactoryGirl.create(:user)

      nominated_good = FactoryGirl.create(:good, :done)
      nominated_good.nominee.user_id = @user.id
      nominated_good.nominee.save!

      not_nominated_good = FactoryGirl.create(:good)

      get :nominations_for, {
        format: :json,
        id: @user.id
      }

      json = jsonify(response)
      assert_equal 2, Good.all.count
      assert_equal 1, json.traverse(:goods).count
    end
  end

  class UsersController::FollowedBy < DoGood::ActionControllerTestCase
    test "route" do
      assert_routing '/users/hammy/followed_by', {
        controller: "users",
        action: "followed_by",
        id: "hammy"
      }
    end

    test "should return goods that a user followed" do
      @user = FactoryGirl.create(:user)
      followed_good = FactoryGirl.create(:good)
      posted_good = FactoryGirl.create(:good, user: @user)
      irrelevant_good = FactoryGirl.create(:good)

      @user.follow(followed_good)

      get :followed_by, {
        format: :json,
        id: @user.id
      }

      json = jsonify(response)
      assert_equal 3, Good.all.count
      assert_equal 1, json.traverse(:goods).count
    end
  end

  class UsersController::VotedBy < DoGood::ActionControllerTestCase
    test "route" do
      assert_routing '/users/hammy/voted_by', {
        controller: "users",
        action: "voted_by",
        id: "hammy"
      }
    end

    test "should return goods that a certain user likes" do
      @user = FactoryGirl.create(:user)
      liked_good = FactoryGirl.create(:good)
      unliked_good = FactoryGirl.create(:good)

      @user.likes(liked_good)

      get :voted_by, {
        format: :json,
        id: @user.id,
      }

      json = jsonify(response)
      assert_equal 2, Good.all.count
      assert_equal 1, json.traverse(:goods).count
    end
  end

  class UsersController::NominationsBy < DoGood::ActionControllerTestCase
    test "route" do
      assert_routing '/users/hammy/nominations_by', {
        controller: "users",
        action: "nominations_by",
        id: "hammy"
      }
    end

    test "should return goods that a user nominated" do
      @user = FactoryGirl.create(:user)
      posted_good = FactoryGirl.create(:good, :done, user: @user)
      irrelevant_good = FactoryGirl.create(:good)

      get :nominations_by, {
        format: :json,
        id: @user.id
      }

      json = jsonify(response)
      assert_equal 2, Good.all.count
      assert_equal 1, json.traverse(:goods).count
    end
  end

  class UsersControllerTest::UpdateProfile < DoGood::ActionControllerTestCase
    test "route" do
      assert_routing( {
        path: "/users/update_profile",
        method: :put
      }, {
        controller: "users",
        action: "update_profile",
      })
    end

    test "unauthorized if not logged in" do
      post :update_profile, {
        format: :json
      }
      json = jsonify(response)
      assert_response :unauthorized
    end

    test "query" do
      @bob = FactoryGirl.create(:user, :bob)
      sign_in @bob

      put :update_profile, {
        format: :json,
        user: {
          full_name: @bob.full_name,
          biography: @bob.biography,
          location: @bob.location,
          phone: @bob.phone,
          avatar: @bob.avatar
        }
      }
      json = jsonify(response)

      assert_response :success

      assert_equal @bob.full_name, json.traverse(:users, :full_name)
    end

    test "query fails with nonsense parameters" do
      @bob = FactoryGirl.create(:user, :bob)
      sign_in @bob

      put :update_profile, {
        format: :json,
        user: {
          full_name: "@#Q@#dofuDJLKJVBBVV√√"
        }
      }
      json = jsonify(response)

      assert_response :internal_server_error

      assert_equal ["Unable to update your details."], json.traverse(:errors, :messages)
    end
  end

  class UsersControllerTest::UpdatePassword < DoGood::ActionControllerTestCase
    test "route" do
      assert_routing( {
        path: "/users/update_password",
        method: :put
      }, {
        controller: "users",
        action: "update_password",
      })
    end

    test "unauthorized if not logged in" do
      post :update_password, {
        format: :json
      }
      json = jsonify(response)
      assert_response :unauthorized
    end

    test "query succeeds" do
      @bob = FactoryGirl.create(:user, :bob)
      sign_in @bob
      new_password = "iliketony"

      put :update_password, {
        format: :json,
        user: {
          current_password: @bob.password,
          password: new_password,
          password_confirmation: new_password
        }
      }
      json = jsonify(response)

      assert_response :success

      assert_equal @bob.full_name, json.traverse(:users, :full_name)
    end

    test "query fails with nonsense parameters" do
      @bob = FactoryGirl.create(:user, :bob)
      sign_in @bob

      put :update_password, {
        format: :json,
        user: {
          full_name: @bob.full_name
        }
      }
      json = jsonify(response)

      assert_response :internal_server_error

      assert_equal ["Unable to update your password."], json.traverse(:errors, :messages)
    end
  end

  class UsersControllerTest::Social < DoGood::ActionControllerTestCase
    test "route" do
      assert_routing( {
        path: "/users/social",
        method: :post
      }, {
        controller: "users",
        action: "social",
      })
    end

    test "unauthorized if not logged in" do
      post :social, {
        format: :json
      }
      json = jsonify(response)
      assert_response :unauthorized
    end

    test "query succeeds" do
      @bob = FactoryGirl.create(:user, :bob)
      sign_in @bob
      twitter_id = "iliketony"
      facebook_id = "NOIDONT"

      post :social, {
        format: :json,
        user: {
          twitter_id: twitter_id,
          facebook_id: facebook_id
        }
      }
      json = jsonify(response)

      assert_response :success

      assert_equal @bob.full_name, json.traverse(:users, :full_name)
      assert_equal User.find(@bob.id).twitter_id, twitter_id
      assert_equal User.find(@bob.id).facebook_id, facebook_id
    end

    test "should fail on db error" do
      any_instance_of(User) do |klass|
          stub(klass).update_attributes { false }
      end
      @bob = FactoryGirl.create(:user, :bob)
      sign_in @bob
      twitter_id = "iliketony"
      facebook_id = "NOIDONT"

      post :social, {
        format: :json,
        user: {
          twitter_id: twitter_id,
          facebook_id: facebook_id
        }
      }
      json = jsonify(response)

      assert_response :internal_server_error
    end
  end

  class UsersControllerTest::RemoveAvatar < DoGood::ActionControllerTestCase
    test "route" do
      assert_routing( {
        path: "/users/remove_avatar",
        method: :delete
      }, {
        controller: "users",
        action: "remove_avatar",
      })
    end

    test "unauthorized if not logged in" do
      delete :remove_avatar, {
        format: :json
      }
      json = jsonify(response)
      assert_response :unauthorized
    end

    test "query succeeds" do
      @bob = FactoryGirl.create(:user, :bob)
      sign_in @bob

      delete :remove_avatar, {
        format: :json
      }
      assert_response :success
    end

    test "query fails" do
      @bob = FactoryGirl.create(:user, :bob)

      @bob.full_name = ""
      @bob.save(validate: false)

      sign_in @bob

      delete :remove_avatar, {
        format: :json
      }

      assert_response :internal_server_error
    end
  end

  class UsersControllerTest::Rank < DoGood::ActionControllerTestCase
    test "route" do
      assert_routing( {
        path: "/users/1/rank",
        method: :get
      }, {
        controller: "users",
        action: "rank",
        id: "1"
      })
    end

    test "rank for another user" do
      @bob = FactoryGirl.create(:user, :bob)

      get :rank, {
        format: :json,
        id: @bob.id
      }
      json = jsonify(response)

      assert_response :success
      assert_equal @bob.rank, json.traverse(:rank)
    end
  end

  class UsersControllerTest::Points < DoGood::ActionControllerTestCase
    test "route" do
      assert_routing( {
        path: "/users/points",
        method: :get
      }, {
        controller: "users",
        action: "points"
      })
    end

    test "query succeeds" do
      @bob = FactoryGirl.create(:user, :bob)
      sign_in @bob

      get :points, {
        format: :json
      }
      json = jsonify(response)

      assert_response :success

      assert_equal @bob.points, json.traverse(:users, :points)
    end

    test "query fails without a current user" do
      get :points, {
        format: :json,
        id: "1"
      }
      json = jsonify(response)

      assert_response :unauthorized
    end
  end

  class UsersControllerTest::Status < DoGood::ActionControllerTestCase
    test "route" do
      assert_routing( {
        path: "/users/1/status",
        method: :get
      }, {
        controller: "users",
        action: "status",
        id: "1"
      })
    end
  end

  class UsersControllerTest::ValidateName < DoGood::ActionControllerTestCase
    test "route" do
      assert_routing( {
        path: "/users/validate_name",
        method: :post
      }, {
        controller: "users",
        action: "validate_name"
      })
    end

    test "with a valid name" do
      @bob = FactoryGirl.create(:user)
      post :validate_name, {
        format: :json,
        user: {
          full_name: @bob.full_name,
          biography: @bob.biography,
          location: @bob.location,
          phone: @bob.phone,
          avatar: @bob.avatar
        }
      }
      json = jsonify(response)

      assert_response :success
    end

    test "with an invalid name" do
      @bob = FactoryGirl.create(:user)
      post :validate_name, {
        format: :json,
        user: {
          full_name: "@23lkj23ASDF###"
        }
      }
      json = jsonify(response)

      assert_response :unprocessable_entity
    end
  end
end

