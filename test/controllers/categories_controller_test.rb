require 'test_helper'

class CategoriesControllerTest < DoGood::ActionControllerTestCase
  tests CategoriesController

  test "should get index" do
    get :index, {
      format: :json
    }
    assert_response :success
  end
end
