class DevicesControllerTest < DoGood::ActionControllerTestCase
  tests DevicesController

  test "route" do
    assert_routing( {
      path: "/devices/token",
      method: :put
    }, {
      controller: "devices",
      id: "token",
      action: "update"
    })
  end

  test "unauthorized update" do
    put :update, {
      format: :json,
      id: "token"
    }

    assert_response :unauthorized
  end

  test "with a valid token" do
    @bob = FactoryGirl.create(:user)
    sign_in @bob

    put :update, {
      format: :json,
      id: "token"
    }

    json = jsonify(response)

    assert_response :success
  end

  test "destroy route" do
    assert_routing( {
      path: "/devices/token",
      method: :delete
    }, {
      controller: "devices",
      id: "token",
      action: "destroy"
    })
  end

  test "unauthorized destroy" do
    put :destroy, {
      format: :json,
      id: "token"
    }

    assert_response :unauthorized
  end

  test "destroys with a valid token" do
    @bob = FactoryGirl.create(:user)
    @device = FactoryGirl.create(:device)
    sign_in @bob

    delete :destroy, {
      format: :json,
      id: @device.token
    }

    json = jsonify(response)

    assert_response :success
  end
end

