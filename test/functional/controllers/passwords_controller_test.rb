require 'test_helper'

class PasswordsControllerTest < DoGood::ActionControllerTestCase
  tests PasswordsController

  context "create" do
    def setup
      super

      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = FactoryGirl.create(:user, :bob)
    end

    test "should allow access with the right parameters" do
      post :create, {
        format: :json,
        user: {
          email: @user.email
        }
      }
      assert_response :success
    end

    test "route" do
      assert_routing '/users/1', {
        controller: "users",
        action: "show",
        id: "1"
      }
    end

    test "should fail for a non-existing email address" do
      @non_user = FactoryGirl.build(:user, :tony)
      post :create, {
        format: :json,
        user: {
          email: @non_user.email
        }
      }
      json = jsonify(response)

      assert_response :unprocessable_entity
    end

    test "should be successful for an existing email address" do
      post :create, {
        format: :json,
        user: {
          email: @user.email
        }
      }
      json = jsonify(response)

      assert_response :success
    end
  end

  context "update" do
  end
end

