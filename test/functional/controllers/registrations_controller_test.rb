require 'test_helper'

class RegistrationsControllerTest < DoGood::ActionControllerTestCase
  tests RegistrationsController

  context "create" do
    def setup
      super

      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = FactoryGirl.build(:user, :bob)
    end

    test "should be successful for the proper authorization" do
      post :create, {
        format: :json,
        user: {
          full_name: @user.full_name,
          email: @user.email,
          password: @user.password
        }
      }
      json = jsonify(response)

      assert_response :success
      assert_equal @user.email, json.traverse(:DAPI, :response, :users, :email)
      assert_equal User.count, 1
    end

    test "should be unsuccessful without params" do
      post :create, {
        format: :json,
      }

      assert_response 422
    end

    context "validity" do
      test "needs valid full name" do
        post :create, {
          format: :json,
          user: {
            full_name: "",
            email: @user.email,
            password: @user.password
          }
        }

        assert_response 422
      end

      test "needs valid email" do
        post :create, {
          format: :json,
          user: {
            full_name: @user.full_name,
            email: "",
            password: @user.password
          }
        }

        assert_response 422
      end

      test "needs valid password" do
        post :create, {
          format: :json,
          user: {
            full_name: @user.full_name,
            email: @user.email,
            password: "bljka"
          }
        }

        assert_response 422
      end

      test "should also accept a profile image, full name & phone" do
        post :create, {
          format: :json,
          user: {
            full_name: @user.full_name,
            email: @user.email,
            password: "bljkaadslfkj",
            avatar: "bljka"
          }
        }

        assert_response :success
      end
    end
  end
end

