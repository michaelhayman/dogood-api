require 'test_helper'

class UsersControllerTest < DoGood::ActionControllerTestCase
  include Devise::TestHelpers

  tests UsersController

  context "index" do
  end

  context "show" do
    test "route" do
      assert_routing '/users/1', {
        controller: "users",
        action: "show",
        id: "1"
      }
    end

    test "request should be successful when correct param ID is passed" do
      @user = FactoryGirl.create(:user, :bob)

      get :show, {
        format: :json,
        id: @user.id
      }

      json = jsonify(response)
      assert_response :success

      assert_equal @user.full_name, json.traverse(:DAPI, :response, :users, :full_name)
    end
  end

  context "search" do
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
        :search => 'Michael'
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

      assert_equal @bob.email, json.traverse(:DAPI, :response, :users, 0, :email)
    end
  end

  context "search_by_emails" do
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
      assert_response :error
    end

    test "request should be successful when the correct params are passed" do
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

      assert_equal @bob.email, json.traverse(:DAPI, :response, :users, 0, :email)
      assert_equal @tony.email, json.traverse(:DAPI, :response, :users, 1, :email)
    end
  end

  context "search_by_twitter_ids" do
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
      assert_response :error
    end

    test "request should be successful when correct params are passed" do
      @bob = FactoryGirl.create(:user, :bob)
      @tony = FactoryGirl.create(:user, :tony)

      twitters = [ @bob.twitter_id, @tony.twitter_id ]

      get :search_by_twitter_ids, {
        format: :json,
        twitter_ids: twitters
      }

      json = HashWithIndifferentAccess.new(JSON.load(response.body))
      assert_response :success

      assert_equal @bob.email, json.traverse(:DAPI, :response, :users, 0, :email)
      assert_equal @tony.email, json.traverse(:DAPI, :response, :users, 1, :email)
    end
  end

  context "search_by_facebook_ids" do
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
      assert_response :error
    end

    test "request should be successful when correct params are passed" do
      @bob = FactoryGirl.create(:user, :bob)
      @tony = FactoryGirl.create(:user, :tony)

      facebooks = [ @bob.facebook_id, @tony.facebook_id ]

      get :search_by_facebook_ids, {
        format: :json,
        facebook_ids: facebooks
      }
      json = jsonify(response)

      assert_response :success

      assert_equal @bob.email, json.traverse(:DAPI, :response, :users, 0, :email)
      assert_equal @tony.email, json.traverse(:DAPI, :response, :users, 1, :email)
    end
  end

  context "likers" do
    test "route" do
      assert_routing '/users/likers', {
        controller: "users",
        action: "likers"
      }
    end

    test "request should be successful when correct params are passed" do
      @bob = FactoryGirl.create(:user, :bob)
      @good = FactoryGirl.create(:good)
      @good.liked_by @bob

      get :likers, {
        format: :json,
        type: "Good",
        id: @good.id
      }
      json = jsonify(response)

      assert_response :success

      assert_equal @bob.email, json.traverse(:DAPI, :response, :users, 0, :email)
    end
  end

  context "followers" do
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

      assert_equal @bob.email, json.traverse(:DAPI, :response, :users, 0, :email)
    end

    test "users" do
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

      assert_equal @bob.email, json.traverse(:DAPI, :response, :users, 0, :email)
    end
  end

  context "following" do
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

      assert_equal @tony.email, json.traverse(:DAPI, :response, :users, 0, :email)
    end
  end

  context "update_profile" do
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

      assert_equal @bob.email, json.traverse(:DAPI, :response, :users, :email)
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

      assert_response :error

      assert_equal ["Unable to update your details."], json.traverse(:DAPI, :response, :errors, :messages)
    end
  end

  context "update_password" do
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

      assert_equal @bob.email, json.traverse(:DAPI, :response, :users, :email)
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

      assert_response :error

      assert_equal ["Unable to update your password."], json.traverse(:DAPI, :response, :errors, :messages)
    end
  end

  context "social" do
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

      assert_equal @bob.email, json.traverse(:DAPI, :response, :users, :email)
      assert_equal User.find(@bob.id).twitter_id, twitter_id
      assert_equal User.find(@bob.id).facebook_id, facebook_id
    end
  end

  context "remove_avatar" do
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
      @bob.save(:validate => false)

      sign_in @bob

      delete :remove_avatar, {
        format: :json
      }

      assert_response :error
    end
  end

  context "score" do
    test "route" do
      assert_routing( {
        path: "/users/1/score",
        method: :get
      }, {
        controller: "users",
        action: "score",
        id: "1"
      })
    end

    test "score for another user" do
      @bob = FactoryGirl.create(:user, :bob)

      get :score, {
        format: :json,
        id: @bob.id
      }
      json = jsonify(response)

      assert_response :success
      assert_equal @bob.score, json.traverse(:DAPI, :response, :score)
    end
  end

  context "points" do
    test "route" do
      assert_routing( {
        path: "/users/1/points",
        method: :get
      }, {
        controller: "users",
        action: "points",
        id: "1"
      })
    end

    test "query succeeds" do
      @bob = FactoryGirl.create(:user, :bob)
      sign_in @bob

      get :points, {
        format: :json,
        id: @bob.id
      }
      json = jsonify(response)

      assert_response :success

      assert_equal @bob.points, json.traverse(:DAPI, :response, :points)
    end

    test "query fails without a current user" do
      get :points, {
        format: :json,
        id: "1"
      }
      json = jsonify(response)

      assert_response 401
    end
  end

  context "status" do
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

  context "validate_name" do
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

      assert_response :error
    end
  end
end

