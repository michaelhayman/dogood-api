require 'test_helper'

class FollowsControllerTest < DoGood::ActionControllerTestCase
  tests FollowsController

  context "create" do
    test "route" do
      assert_routing( {
        path: '/follows',
        method: :post
      }, {
        controller: "follows",
        action: "create",
      })
    end
  end

  context "remove" do
    test "route" do
      assert_routing( {
        path: '/follows/remove',
        method: :delete
      }, {
        controller: "follows",
        action: "remove"
      })
    end
  end
end

