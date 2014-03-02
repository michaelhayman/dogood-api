require 'test_helper'

class TagsControllerTest < DoGood::ActionControllerTestCase
  tests TagsController
  def setup
    super
    @tag = FactoryGirl.create(:tag)
    @tag_2 = FactoryGirl.create(:tag, :cool)
    @tag_3 = FactoryGirl.create(:tag, :weird)
  end

  context "index" do
    test "route" do
      assert_routing '/tags', {
        controller: "tags",
        action: "index"
      }
    end

    test "request should be successful with no parameters" do
      get :index, {
        format: :json
      }
      json = jsonify(response)

      assert_response :success
      assert_equal @tag.id, json.traverse(:DAPI, :response, :tags, 0, :id)
    end
  end

  context "search" do
    test "route" do
      assert_routing '/tags/search', {
        controller: "tags",
        action: "search"
      }
    end

    test "request should be successful with no parameters" do
      get :search, {
        format: :json
      }
      assert_response :success
    end

    test "request should be successful with no parameters" do
      get :search, {
        format: :json
      }
      json = jsonify(response)

      assert_response :success
      assert_equal Tag.count, json.traverse(:DAPI, :response, :total_results)
    end

    test "request should be successful with parameters" do
      get :search, {
        format: :json,
        q: "awesome"
      }
      json = jsonify(response)

      assert_response :success
      assert_equal @tag.id, json.traverse(:DAPI, :response, :tags, 0, :id)
    end
  end

  context "popular" do
    test "route" do
      assert_routing '/tags/popular', {
        controller: "tags",
        action: "popular"
      }
    end

    test "request should be successful with parameters" do
      10.times do
        @tag = FactoryGirl.create(:tag, :cool)
        FactoryGirl.create(:tagging, hashtag: @tag)
      end

      get :popular, {
        format: :json
      }
      json = jsonify(response)

      assert_response :success
      assert_equal 10, json.traverse(:DAPI, :response, :total_results)
    end
  end
end

