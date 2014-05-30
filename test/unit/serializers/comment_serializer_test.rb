require 'test_helper'

class CommentSerializerTest < DoGood::TestCase
  def expected_hash
    {
      comments: {
        comment: @comment.comment,
        created_at: @comment.created_at,
        entities: @comment.entities,
        user: {
          id: @comment.user.id,
          avatar_url: @comment.user.avatar_url,
          full_name: @comment.user.full_name
        }
      }
    }
  end

  def setup
    super
    @user = FactoryGirl.create(:user)
    @comment = FactoryGirl.create(:comment, user: @user).decorate

    @serializer = CommentSerializer.new @comment, root: "comments"
  end

  test "api" do
    assert_equal expected_hash.to_json, @serializer.to_json
  end
end

