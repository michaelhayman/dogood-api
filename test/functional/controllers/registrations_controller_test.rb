require 'test_helper'

class RegistrationsControllerTest < DoGood::ActionControllerTestCase
  tests RegistrationsController

  def setup
    super

    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = FactoryGirl.build(:user, :bob)
  end

  test "sign up should be successful for the proper authorization" do
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
    assert_equal @user.full_name, json.traverse(:users, :full_name)
    assert_equal User.count, 1
  end

  test "should be unsuccessful without params" do
    post :create, {
      format: :json,
    }

    assert_response :unprocessable_entity
  end

  test "needs valid full name" do
    post :create, {
      format: :json,
      user: {
        full_name: "",
        email: @user.email,
        password: @user.password
      }
    }

    assert_response :unprocessable_entity
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

    assert_response :unprocessable_entity
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

    assert_response :unprocessable_entity
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

