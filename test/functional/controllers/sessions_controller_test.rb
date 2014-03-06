require 'test_helper'

class SessionsControllerTest < DoGood::ActionControllerTestCase
  tests SessionsController

  context "create" do
    def setup
      super

      @user = FactoryGirl.create(:user, :bob)
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end

    test "should be successful for the proper authorization" do
      post :create, {
        format: :json,
        user: {
          email: @user.email,
          password: @user.password
        }
      }

      assert_response :success
    end

    test "should be unsuccessful without params" do
      post :create, {
        format: :json,
      }

      assert_response :unprocessable_entity
    end

    test "should be unsuccessful without valid email and password" do
      post :create, {
        format: :json,
        user: {
          email: @user.email,
          password: "madeup"
        }
      }

      assert_response :unprocessable_entity
    end
  end
end

