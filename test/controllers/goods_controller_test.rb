require 'test_helper'

class GoodsControllerTest < DoGood::ActionControllerTestCase
  tests GoodsController

  context "index" do
    test "request should be successful always" do
      get :index, {
        format: :json
      }
      assert_response :success
    end

    test "should return a list of listings matching the given ids" do
      @good = FactoryGirl.create(:good)

      get :index, {
        format: :json
      }

      json = HashWithIndifferentAccess.new(JSON.load(response.body))
      assert_equal @good.id, json.traverse(:goods, 0, :id)
    end
  end
end

