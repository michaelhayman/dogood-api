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

    test "should return goods matching the given ids" do
      @good = FactoryGirl.create(:good)

      get :index, {
        format: :json
      }

      json = HashWithIndifferentAccess.new(JSON.load(response.body))
      assert_equal @good.id, json.traverse(:goods, 0, :id)
    end

    test "should return a list of goods matching the given tag id" do
      hashtag = "awesome"
      @good = FactoryGirl.create(:good, :tagged)

      get :tagged, {
        format: :json,
        id: SimpleHashtag::Hashtag.find_by_name('awesome')
      }

      json = HashWithIndifferentAccess.new(JSON.load(response.body))
      assert_equal @good.id, json.traverse(:goods, 0, :id)
    end

    test "should return a list of goods matching the given tag name" do
      hashtag = "awesome"

      @good = FactoryGirl.create(:good, :tagged)

      get :tagged, {
        format: :json,
        name: hashtag
      }

      json = HashWithIndifferentAccess.new(JSON.load(response.body))
      assert_equal @good.id, json.traverse(:goods, 0, :id)
    end

    test "should return a list of goods in order of popularity" do
      @lame_good = FactoryGirl.create(:good, :lame)
      @average_good = FactoryGirl.create(:good, :average)
      @popular_good = FactoryGirl.create(:good, :popular)

      get :popular, {
        format: :json
      }

      json = HashWithIndifferentAccess.new(JSON.load(response.body))
      assert_equal @popular_good.id, json.traverse(:goods, 0, :id)
      assert_equal @average_good.id, json.traverse(:goods, 1, :id)
      assert_equal @lame_good.id, json.traverse(:goods, 2, :id)
    end

    test "should return a list of goods in order of popularity" do
      good = FactoryGirl.create(:good)
      sydney_good = FactoryGirl.create(:good, :sydney)

      get :nearby, {
        format: :json,
        lat: good.lat,
        lng: good.lng
      }

      json = HashWithIndifferentAccess.new(JSON.load(response.body))
      assert_equal 1, json.traverse(:goods).count
    end

    test "should return a list of goods that a certain user likes" do
      @user = FactoryGirl.create(:user)
      liked_good = FactoryGirl.create(:good)
      unliked_good = FactoryGirl.create(:good)

      @user.likes(liked_good)

      get :liked_by, {
        format: :json,
        user_id: @user.id,
      }

      json = HashWithIndifferentAccess.new(JSON.load(response.body))
      assert_equal 1, json.traverse(:goods).count
    end
  end
end

