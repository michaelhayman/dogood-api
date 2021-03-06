class GoodsControllerTest < DoGood::ActionControllerTestCase
  tests GoodsController

  class GoodsController::Index < DoGood::ActionControllerTestCase
    test "route" do
      assert_routing '/goods', {
        controller: "goods",
        action: "index"
      }
    end

    test "difficult to handle parameters" do
      get :index, {
        format: :json,
        page: ""
      }
      assert_response :success
    end

    test "the index json" do
      @good = FactoryGirl.create(:good)
      @good_2 = FactoryGirl.create(:good)
      @comment_on_2 = FactoryGirl.create(:comment, commentable_id: @good_2.id)
      @entity = FactoryGirl.create(:entity, entityable_id: @comment_on_2.id)

      get :index, {
        format: :json
      }
      json = jsonify(response)

      assert_equal Good.count, json.traverse(:goods).count
    end

    test "the goods matching a given category id" do
      @user = FactoryGirl.create(:user)
      @good = FactoryGirl.create(:good)
      @good.liked_by @user
      sign_in @user
      @health_good = FactoryGirl.create(:good, :health)

      get :index, {
        format: :json,
        category_id: @good.category_id
      }

      json = jsonify(response)
      assert_equal 2, Good.all.count

      assert_equal 1, json.traverse(:goods).count
    end

    test "the goods which are to do" do
      @user = FactoryGirl.create(:user)
      @good = FactoryGirl.create(:good)

      @health_good = FactoryGirl.create(:good, :health, done: true)

      get :index, {
        format: :json,
        done: true
      }

      json = jsonify(response)
      assert_equal 2, Good.all.count

      assert_equal 1, json.traverse(:goods).count
    end

    test "the goods which are done" do
      @user = FactoryGirl.create(:user)
      @good = FactoryGirl.create(:good)

      @health_good = FactoryGirl.create(:good, :health, done: true)

      get :index, {
        format: :json,
        done: true
      }

      json = jsonify(response)
      assert_equal 2, Good.all.count

      assert_equal 1, json.traverse(:goods).count
    end
  end

  class GoodsController::Show < DoGood::ActionControllerTestCase
    test "route" do
      assert_routing '/goods/1', {
        controller: "goods",
        action: "show",
        id: "1"
      }
    end

    test "should return goods matching the given ids" do
      @good = FactoryGirl.create(:good)
      @good_2 = FactoryGirl.create(:good)
      @comment_on_2 = FactoryGirl.create(:comment, commentable_id: @good_2.id)

      get :show, {
        format: :json,
        id: @good_2.id
      }
      json = jsonify(response)

      assert_equal @good_2.id, json.traverse(:goods, 0, :id)
    end

  end

  class GoodsController::Tagged < DoGood::ActionControllerTestCase
    test "route" do
      assert_routing '/goods/tagged', {
        controller: "goods",
        action: "tagged"
      }
    end

    test "should return goods matching the given tag name" do
      hashtag = "#awesome"

      @good = FactoryGirl.create(:good, :tagged)

      get :tagged, {
        format: :json,
        name: hashtag
      }

      json = jsonify(response)
      assert_equal @good.id, json.traverse(:goods, 0, :id)
    end
  end

  class GoodsController::Popular < DoGood::ActionControllerTestCase
    test "route" do
      assert_routing '/goods/popular', {
        controller: "goods",
        action: "popular"
      }
    end

    test "should return goods in order of popularity" do
      @unpopular_good = FactoryGirl.create(:good, :lame)
      @average_good = FactoryGirl.create(:good, :average)
      @popular_good = FactoryGirl.create(:good, :popular)

      get :popular, {
        format: :json
      }

      json = jsonify(response)
      assert_equal 3, Good.all.count
      assert_equal @popular_good.id, json.traverse(:goods, 0, :id)
      assert_equal @average_good.id, json.traverse(:goods, 1, :id)
      assert_equal @unpopular_good.id, json.traverse(:goods, 2, :id)
    end
  end

  class GoodsController::Nearby < DoGood::ActionControllerTestCase
    test "route" do
      assert_routing '/goods/nearby', {
        controller: "goods",
        action: "nearby"
      }
    end

    test "should return goods that are nearby" do
      good = FactoryGirl.create(:good)
      sydney_good = FactoryGirl.create(:good, :sydney)

      get :nearby, {
        format: :json,
        lat: good.lat,
        lng: good.lng
      }

      json = jsonify(response)
      assert_equal 2, Good.all.count
      assert_equal 1, json.traverse(:goods).count
    end
  end

  class GoodsController::NominationsFor < DoGood::ActionControllerTestCase
    test "should return goods that a user was nominated for" do
      @user = FactoryGirl.create(:user)
      get :nominations_for, {
        format: :json,
        user_id: @user.id
      }

      assert_redirected_to "https://test.host/users/#{@user.id}/nominations_for"
    end
  end

  class GoodsController::FollowedBy < DoGood::ActionControllerTestCase
    test "should return goods that a user followed" do
      @user = FactoryGirl.create(:user)
      get :followed_by, {
        format: :json,
        user_id: @user.id
      }

      assert_redirected_to "https://test.host/users/#{@user.id}/followed_by"
    end
  end

  class GoodsController::VotedBy < DoGood::ActionControllerTestCase
    test "should return goods that a certain user likes" do
      @user = FactoryGirl.create(:user)
      get :voted_by, {
        format: :json,
        user_id: @user.id,
      }

      assert_redirected_to "https://test.host/users/#{@user.id}/voted_by"
    end
  end

  class GoodsController::NominationsBy < DoGood::ActionControllerTestCase
    test "should return goods that a user nominated" do
      @user = FactoryGirl.create(:user)
      get :nominations_by, {
        format: :json,
        user_id: @user.id
      }

      assert_redirected_to "https://test.host/users/#{@user.id}/nominations_by"
    end
  end

  class GoodsController::HelpWantedBy < DoGood::ActionControllerTestCase
    test "should return goods for which a user asked for help" do
      @user = FactoryGirl.create(:user)
      get :help_wanted_by, {
        format: :json,
        user_id: @user.id
      }

      assert_redirected_to "https://test.host/users/#{@user.id}/help_wanted_by"
    end
  end

  class GoodsController::Create < DoGood::ActionControllerTestCase
    def setup
      super
      @user = FactoryGirl.create(:user)
      sign_in @user
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end

    test "route" do
      assert_routing( {
        path: '/goods',
        method: :post
      }, {
        controller: "goods",
        action: "create",
      })
    end

    test "should not allow access if the user is not authenticated" do
      sign_out @user
      @good = FactoryGirl.build(:good)

      post :create, {
        format: :json,
        good: {
          caption: @good.caption,
          user_id: @good.user.id,
          nominee_attributes: {
            full_name: @good.nominee.full_name
          }
        }
      }
      assert_response :unauthorized
    end

    test "for an authenticated user should not allow no parameters to be passed" do
      stub(Good).just_created_by { false }
      sign_in @user
      post :create, {
        format: :json,
      }
      json = jsonify(response)
      assert_response :unprocessable_entity
    end

    test "should not allow two goods to be posted too quickly" do
      sign_in @user
      stub(Good).just_created_by { true }

      3.times do
        post :create, {
          format: :json,
        }
      end
      assert_response :too_many_requests
    end

    test "should fail for db error" do
      sign_in @user

      @good = FactoryGirl.build(:good)
      stub(Good).just_created_by { false }
      stub_save_method(Good)

      post :create, {
        format: :json,
        good: {
          caption: @good.caption,
          user_id: @good.user.id,
          done: false
        }
      }
      assert_response :internal_server_error
    end

    test "done good" do
      any_instance_of(Good) do |klass|
        stub(klass).send_invite? { false }
        stub(klass).send_notification { false }
      end

      stub(Good).just_created_by { false }

      @good = FactoryGirl.build(:good, :done, user: @user)

      sign_in @user

      post :create, {
        format: :json,
        good: {
          caption: @good.caption,
          done: true,
          user_id: @good.user.id,
          category_id: @good.category_id,
          nominee_attributes: {
            full_name: @good.nominee.full_name
          }
        }
      }

      assert_response :success
      assert_equal 1, Good.all.count

      @created_good = Good.first
      assert_equal @created_good.caption, @good.caption
      assert_equal @created_good.user.points, Good::GOOD_POINTS
    end

    test "todo good (& it should ignore the nominee attributes)" do
      stub(Good).just_created_by { false }
      sign_in @user

      @good = FactoryGirl.build(:good, user: @user)

      post :create, {
        format: :json,
        good: {
          caption: @good.caption,
          user_id: @good.user.id,
          done: false,
          category_id: @good.category.id,
          nominee_attributes: {
            full_name: @good.nominee.full_name
          }
        }
      }

      assert_response :success
      assert_equal 1, Good.all.count

      @created_good = Good.first
      assert_equal @created_good.caption, @good.caption
    end
  end

  class GoodsController::Destroy < DoGood::ActionControllerTestCase
    def setup
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

    test "route" do
      assert_routing( {
        path: '/goods/1',
        method: :delete
      }, {
        controller: "goods",
        id: '1',
        action: "destroy",
      })
    end

    test "should not allow access if the user is not authenticated" do
      sign_out @user
      @good = FactoryGirl.create(:good)

      delete :destroy, {
        format: :json,
        id: @good.id
      }
      assert_response :unauthorized
    end

    test "should not allow a user to delete a good which isn't theirs" do
      @bob = FactoryGirl.create(:user, :bob)
      @good = FactoryGirl.create(:good, user: @bob)

      delete :destroy, {
        format: :json,
        id: @good.id
      }
      assert_response :unprocessable_entity
    end

    test "should fail on a database error for an authenticated user" do
      any_instance_of(Good) do |klass|
        stub(klass).destroy { false }
      end

      @good = FactoryGirl.create(:good, user: @user)

      delete :destroy, {
        format: :json,
        id: @good.id
      }
      assert_response :internal_server_error
    end

    test "should work for an authenticated user" do
      @good = FactoryGirl.create(:good, user: @user)

      delete :destroy, {
        format: :json,
        id: @good.id
      }
      assert_response :success
    end
  end
end

