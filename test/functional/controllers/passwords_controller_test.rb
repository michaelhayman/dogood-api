require 'test_helper'

class PasswordsControllerTest < DoGood::ActionControllerTestCase
  tests PasswordsController

  context "create" do
    def setup
      super

      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = FactoryGirl.build(:user, :bob)
    end

    test "should fail for a non-existing email address" do
      post :create, {
        format: :json,
        user: {
          email: @user.email
        }
      }
      json = jsonify(response)

      assert_response 422
    end

    test "should be successful for an existing email address" do
      @user = FactoryGirl.create(:user, :bob)
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
end

