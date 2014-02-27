require 'test_helper'

class CommentsControllerTest < DoGood::ActionControllerTestCase
  include Devise::TestHelpers

  tests CommentsController

  context "index" do
    test "route" do
      assert_routing '/comments', {
        controller: "comments",
        action: "index"
      }
    end

    test "request should find comments" do
      @comment = FactoryGirl.create(:comment)

      get :index, {
        format: :json,
        good_id: @comment.commentable_id
      }

      json = jsonify(response)
      assert_response :success

      assert_equal @comment.comment, json.traverse(:DAPI, :response, :comments, 0, :comment)
    end
  end

  context "create" do
    test "route" do
      assert_routing({
        path: '/comments',
        method: :post
      }, {
        controller: "comments",
        action: "create"
      })
    end

    test "request should create a basic comment" do
      @user = FactoryGirl.create(:user)
      sign_in @user

      @comment = FactoryGirl.create(:comment, :user => @user)

      post :create, {
        format: :json,
        comment: {
          commentable_id: @comment.commentable_id,
          commentable_type: @comment.commentable_type,
          comment: @comment.comment,
          user_id: @comment.user_id
        }
      }

      json = jsonify(response)
      assert_response :success

      assert_equal @comment.comment, json.traverse(:DAPI, :response, :comments, :comment)
    end

    xtest "request should create a comment with entities" do
      # entities_attributes: {
      #   entityable_id: 1,
      #   entityable_type: "Good",
      #   link: "assdf",
      #   link_id: 5,
      #   link_type:1,
      #   title: "hey",
      #   range: [ 0, 3 ]
      # }
    end

    xtest "request should fail properly if not authenticated" do
    end

    test "request should fail if validations fail" do
      @user = FactoryGirl.create(:user)
      sign_in @user

      @comment = FactoryGirl.create(:comment, :user => @user)

      post :create, {
        format: :json,
        comment: {
          comment: "",
        }
      }

      json = jsonify(response)
      assert_response :error
    end
  end
end

