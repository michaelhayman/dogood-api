class CommentsControllerTest < DoGood::ActionControllerTestCase
  tests CommentsController

  test "index route" do
    assert_routing '/comments', {
      controller: "comments",
      action: "index"
    }
  end

  test "index request should find comments" do
    @comment = FactoryGirl.create(:comment)

    get :index, {
      format: :json,
      good_id: @comment.commentable_id
    }

    json = jsonify(response)
    assert_response :success

    assert_equal @comment.comment, json.traverse(:comments, 0, :comment)
  end

  test "create route" do
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

    @comment = FactoryGirl.build(:comment, user: @user)

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

    assert_equal @comment.comment, json.traverse(:comments, :comment)
    added_comment = Comment.find_by_commentable_id(@comment.commentable_id)
    assert_equal added_comment.user.points, Comment::COMMENT_POINTS
  end

  test "request should create a comment with entities" do
    skip "not implemented"
    entities_attributes = {
      entityable_id: 1,
      entityable_type: "Good",
      link: "assdf",
      link_id: 5,
      link_type:1,
      title: "hey",
      range: [ 0, 3 ]
    }
  end

  test "request should fail properly if not authenticated" do
    skip "not implemented"
  end

  test "request should fail if validations fail" do
    @user = FactoryGirl.create(:user)
    sign_in @user

    @comment = FactoryGirl.build(:comment, user: @user)

    post :create, {
      format: :json,
      comment: {
        comment: "",
      }
    }

    json = jsonify(response)
    assert_response :internal_server_error
  end
end

