require 'test_helper'

class GoodsControllerTest < DoGood::ActionControllerTestCase
  include Devise::TestHelpers

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

    test "should return goods matching the given category id" do
      @good = FactoryGirl.create(:good)
      @health_good = FactoryGirl.create(:good, :health)

      get :index, {
        format: :json,
        category_id: @good.category_id
      }

      json = HashWithIndifferentAccess.new(JSON.load(response.body))
      assert_equal 2, Good.all.count
      assert_equal 1, json.traverse(:goods).count
    end
  end

  context "tagged" do
    test "should return goods matching the given tag id" do
      hashtag = "awesome"
      @good = FactoryGirl.create(:good, :tagged)

      get :tagged, {
        format: :json,
        id: SimpleHashtag::Hashtag.find_by_name('awesome')
      }

      json = HashWithIndifferentAccess.new(JSON.load(response.body))
      assert_equal @good.id, json.traverse(:goods, 0, :id)
    end

    test "should return goods matching the given tag name" do
      hashtag = "awesome"

      @good = FactoryGirl.create(:good, :tagged)

      get :tagged, {
        format: :json,
        name: hashtag
      }

      json = HashWithIndifferentAccess.new(JSON.load(response.body))
      assert_equal @good.id, json.traverse(:goods, 0, :id)
    end
  end

  context "popular" do
    test "should return goods in order of popularity" do
      @lame_good = FactoryGirl.create(:good, :lame)
      @average_good = FactoryGirl.create(:good, :average)
      @popular_good = FactoryGirl.create(:good, :popular)

      get :popular, {
        format: :json
      }

      json = HashWithIndifferentAccess.new(JSON.load(response.body))
      assert_equal 3, Good.all.count
      assert_equal @popular_good.id, json.traverse(:goods, 0, :id)
      assert_equal @average_good.id, json.traverse(:goods, 1, :id)
      assert_equal @lame_good.id, json.traverse(:goods, 2, :id)
    end
  end

  context "nearby" do
    test "should return goods that are nearby" do
      good = FactoryGirl.create(:good)
      sydney_good = FactoryGirl.create(:good, :sydney)

      get :nearby, {
        format: :json,
        lat: good.lat,
        lng: good.lng
      }

      json = HashWithIndifferentAccess.new(JSON.load(response.body))
      assert_equal 2, Good.all.count
      assert_equal 1, json.traverse(:goods).count
    end
  end

  context "liked_by" do
    test "should return goods that a certain user likes" do
      @user = FactoryGirl.create(:user)
      liked_good = FactoryGirl.create(:good)
      unliked_good = FactoryGirl.create(:good)

      @user.likes(liked_good)

      get :liked_by, {
        format: :json,
        user_id: @user.id,
      }

      json = HashWithIndifferentAccess.new(JSON.load(response.body))
      assert_equal 2, Good.all.count
      assert_equal 1, json.traverse(:goods).count
    end
  end

  context "posted_or_followed_by" do
    test "should return goods that a user posted or followed" do
      @user = FactoryGirl.create(:user)
      followed_good = FactoryGirl.create(:good)
      posted_good = FactoryGirl.create(:good, :user => @user)
      irrelevant_good = FactoryGirl.create(:good)

      @user.follow(followed_good)

      get :posted_or_followed_by, {
        format: :json,
        user_id: @user.id
      }

      json = HashWithIndifferentAccess.new(JSON.load(response.body))
      assert_equal 3, Good.all.count
      assert_equal 2, json.traverse(:goods).count
    end
  end

  context "nominations" do
    test "should return goods that a user was nominated for" do
      @user = FactoryGirl.create(:user)

      nominated_good = FactoryGirl.create(:good)
      nominated_good.nominee.user_id = @user
      nominated_good.nominee.save!

      not_nominated_good = FactoryGirl.create(:good)

      get :nominations, {
        format: :json,
        user_id: @user.id.to_s
      }

      json = HashWithIndifferentAccess.new(JSON.load(response.body))
      assert_equal 2, Good.all.count
      assert_equal 1, json.traverse(:goods).count
    end
  end

  context "create" do
    test "should not allow access if the user is not authenticated" do
      post :create, {
        format: :json
      }
      assert_response 401
    end
  end
end

