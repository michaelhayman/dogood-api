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

      json = HashWithIndifferentAccess.new(JSON.load(response.body))
      assert_response :success

      assert_equal @user.full_name, json.traverse(:DAPI, :response, :users, :full_name)
    end
  end

  context "update_profile" do
  end

  context "update_password" do
  end

  context "social" do
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
      @user = FactoryGirl.create(:user, :bob)
      get :search, {
        format: :json,
        search: @user.full_name
      }

      json = HashWithIndifferentAccess.new(JSON.load(response.body))
      assert_response :success

      assert_equal @user.email, json.traverse(:DAPI, :response, :users, 0, :email)
    end
  end

  context "score" do
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

  context "remove_avatar" do
  end

  context "search_by_twitter_ids" do
  end

  context "search_by_facebook_ids" do
  end

  context "points" do
  end

  context "likers" do
  end

  context "followers" do
  end

  context "following" do
  end

  context "status" do
  end

  context "validate_name" do
  end

  context "validate_name" do
  end
end

