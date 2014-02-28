require 'test_helper'

class TagsControllerTest < DoGood::ActionControllerTestCase
  tests TagsController
  def setup
    super
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
      assert_response :success
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
  end

  context "popular" do
    test "route" do
      assert_routing '/tags/popular', {
        controller: "tags",
        action: "popular"
      }
    end
  end
end

