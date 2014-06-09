class UnsubscribesControllerTest < DoGood::ActionControllerTestCase
  tests UnsubscribesController

  test "route" do
    assert_routing({
      path: '/unsubscribe_email',
      method: :post
    },
    {
      controller: "unsubscribes",
      action: "opt_out"
    })
  end

  test "request should be successful when given correct email" do
    email = "test@test.com"

    post :opt_out, {
      format: :json,
      unsubscribe: {
        email: email
      }
    }

    assert_response :success
    Unsubscribe.opted_out?(email)
  end
end

