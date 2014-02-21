require 'test_helper'

class UsersControllerTest < DoGood::ActionControllerTestCase
  include Devise::TestHelpers

  tests UsersController

  context "index" do
  end

  context "show" do
  end

  context "update_profile" do
  end

  context "update_password" do
  end

  context "social" do
  end

  context "search" do
  end

  context "score" do
  end

  context "search_by_emails" do
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

      assert_equal @bob.email, json.traverse(:user, 0, :email)
      assert_equal @tony.email, json.traverse(:user, 1, :email)
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

