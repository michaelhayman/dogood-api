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

    test "request should be successful when correct params are passed" do
      @bob = FactoryGirl.create(:user, :bob)
      @tony = FactoryGirl.create(:user, :tony)

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
  end

  context "followers" do
    test "route" do
      assert_routing '/users/followers', {
        controller: "users",
        action: "followers"
      }
    end
  end

  context "following" do
    test "route" do
      assert_routing '/users/following', {
        controller: "users",
        action: "following"
      }
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
  end
end

