class ErrorsControllerTest < DoGood::ActionControllerTestCase
  tests ErrorsController

  test "not found route" do
    assert_routing '/404', {
      controller: "errors",
      action: "not_found"
    }
  end

  test "not found method" do
    get :not_found

    assert_response :not_found
  end

  test "exception route" do
    assert_routing '/500', {
      controller: "errors",
      action: "exception"
    }
  end

  test "exception method" do
    get :exception

    assert_response :internal_server_error
  end
end

