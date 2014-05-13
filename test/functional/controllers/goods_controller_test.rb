require 'test_helper'

class GoodsControllerTest < DoGood::ActionControllerTestCase
  include Devise::TestHelpers

  tests GoodsController

  def setup
    super
  end

  context "index" do
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
      @comment_on_2 = FactoryGirl.create(:comment, :commentable_id => @good_2.id)
      @entity = FactoryGirl.create(:entity, :entityable_id => @comment_on_2.id)

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

  context "show" do
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
      @comment_on_2 = FactoryGirl.create(:comment, :commentable_id => @good_2.id)

      get :show, {
        format: :json,
        id: @good_2.id
      }
      json = jsonify(response)

      assert_equal @good_2.id, json.traverse(:goods, :id)
    end

  end

  context "tagged" do
    test "route" do
      assert_routing '/goods/tagged', {
        controller: "goods",
        action: "tagged"
      }
    end

    test "should return goods matching the given tag id" do
      hashtag = "awesome"
      @good = FactoryGirl.create(:good, :tagged)

      get :tagged, {
        format: :json,
        id: SimpleHashtag::Hashtag.find_by_name('awesome')
      }

      json = jsonify(response)
      assert_equal @good.id, json.traverse(:goods, 0, :id)
    end

    test "should return goods matching the given tag name" do
      hashtag = "awesome"

      @good = FactoryGirl.create(:good, :tagged)

      get :tagged, {
        format: :json,
        name: hashtag
      }

      json = jsonify(response)
      assert_equal @good.id, json.traverse(:goods, 0, :id)
    end
  end

  context "popular" do
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

  context "nearby" do
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

  context "liked_by" do
    test "route" do
      assert_routing '/goods/liked_by', {
        controller: "goods",
        action: "liked_by"
      }
    end

    test "should return goods that a certain user likes" do
      @user = FactoryGirl.create(:user)
      liked_good = FactoryGirl.create(:good)
      unliked_good = FactoryGirl.create(:good)

      @user.likes(liked_good)

      get :liked_by, {
        format: :json,
        user_id: @user.id,
      }

      json = jsonify(response)
      assert_equal 2, Good.all.count
      assert_equal 1, json.traverse(:goods).count
    end
  end

  context "posted_or_followed_by" do
    test "route" do
      assert_routing '/goods/posted_or_followed_by', {
        controller: "goods",
        action: "posted_or_followed_by"
      }
    end

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

      json = jsonify(response)
      assert_equal 3, Good.all.count
      assert_equal 2, json.traverse(:goods).count
    end
  end

  context "nominations" do
    test "route" do
      assert_routing '/goods/nominations', {
        controller: "goods",
        action: "nominations"
      }
    end

    test "should return goods that a user was nominated for" do
      @user = FactoryGirl.create(:user)

      nominated_good = FactoryGirl.create(:good, :done)
      nominated_good.nominee.user_id = @user
      nominated_good.nominee.save!

      not_nominated_good = FactoryGirl.create(:good)

      get :nominations, {
        format: :json,
        user_id: @user.id.to_s
      }

      json = jsonify(response)
      assert_equal 2, Good.all.count
      assert_equal 1, json.traverse(:goods).count
    end
  end

  context "create" do
    def setup
      @user = FactoryGirl.create(:user)
      sign_in @user
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

    context "should fail" do
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

      context "for an authenticated user" do
        test "should not allow no parameters to be passed" do
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
      end

      context "should be successful for a fully populated" do
        test "done good" do
          any_instance_of(Good) do |klass|
              stub(klass).send_invite? { false }
          end

          stub(Good).just_created_by { false }

          @good = FactoryGirl.build(:good, :done, :user => @user)

          sign_in @user

          post :create, {
            format: :json,
            good: {
              caption: @good.caption,
              done: true,
              user_id: @good.user.id,
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

        test "todo good (& it should ignore the nominee attributes)" do
          stub(Good).just_created_by { false }
          sign_in @user

          @good = FactoryGirl.build(:good, :user => @user)

          post :create, {
            format: :json,
            good: {
              caption: @good.caption,
              user_id: @good.user.id,
              done: false,
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
    end
  end
end

