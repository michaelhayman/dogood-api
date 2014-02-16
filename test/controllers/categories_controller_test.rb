require 'test_helper'

class CategoriesControllerTest < ActionController::TestCase
  tests CategoriesController

  test "should get index" do
    get :index, {
      format: :json
    }
    assert_response :success
  end

end
