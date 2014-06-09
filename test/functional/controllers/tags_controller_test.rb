class TagsControllerTest < DoGood::ActionControllerTestCase
  tests TagsController

  test "search route" do
    assert_routing '/tags/search', {
      controller: "tags",
      action: "search"
    }
  end

  test "search request should be successful with no parameters" do
    get :search, {
      format: :json
    }
    json = jsonify(response)

    assert_response :success
    assert_equal [], json.traverse(:tags)
  end

  test "search request should be successful with parameters" do
    @tag = FactoryGirl.create(:tag).decorate
    FactoryGirl.create(:tag, :cool)
    FactoryGirl.create(:tag, :weird)

    get :search, {
      format: :json,
      q: "awesome"
    }
    json = jsonify(response)

    assert_response :success
    assert_equal @tag.name, json.traverse(:tags, 0, :name)
  end

  test "search request should be return popular tags if query is empty" do
    @tag = FactoryGirl.create(:tag).decorate
    @tag = FactoryGirl.create(:tag).decorate
    FactoryGirl.create(:tag, :cool)
    FactoryGirl.create(:tag, :weird)

    get :search, {
      format: :json,
      q: ""
    }
    json = jsonify(response)

    assert_response :success
    assert_equal @tag.name, json.traverse(:tags, 0, :name)
  end

  test "popular route" do
    assert_routing '/tags/popular', {
      controller: "tags",
      action: "popular"
    }
  end

  test "popular request should return 10 results" do
    15.times do
      FactoryGirl.create(:tag, title: Faker::Internet.domain_word)
    end

    get :popular, {
      format: :json
    }
    json = jsonify(response)

    assert_response :success
    assert_equal 10, json.traverse(:tags).count
  end
end

