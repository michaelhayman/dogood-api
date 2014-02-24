require 'test_helper'

class CategoriesControllerTest < DoGood::ActionControllerTestCase
  tests CategoriesController

  context "index" do
    test "route" do
      assert_routing '/categories', {
        controller: "categories",
        action: "index"
      }
    end

    test "should get index" do
      get :index, {
        format: :json
      }
      assert_response :success
    end
  end
end
