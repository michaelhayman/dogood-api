class PasswordsControllerTest < DoGood::ActionControllerTestCase
  tests PasswordsController

  def setup
    super

    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = FactoryGirl.create(:user, :bob)
  end

  test "create route" do
    assert_routing({
      path: '/users/password',
      method: :post
    }, {
      controller: "passwords",
      action: "create"
    })
  end


  test "should create password request email with the right parameters" do
    post :create, {
      format: :json,
      user: {
        email: @user.email
      }
    }
    assert_response :success
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

  test "update route" do
    assert_routing({
      path: '/users/password',
      method: :put
    }, {
      controller: "passwords",
      action: "update"
    })
  end

  test "should be successful for a valid reset password token" do
    raw = @user.send_reset_password_instructions
    password = "w4lly!!##"

    put :update, {
      format: :json,
      user: {
        reset_password_token: raw,
        password: password,
        password_confirmation: password
      }
    }
    json = jsonify(response)

    assert_response :success
  end

  test "should be unsuccessful for a invalid reset password token" do
    put :update, {
      format: :json,
      user: {
        email: @user.email
      }
    }
    json = jsonify(response)

    assert_response :unprocessable_entity
  end
end

