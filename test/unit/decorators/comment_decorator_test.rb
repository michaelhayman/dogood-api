require 'test_helper'

class CommentDecoratorTest < DoGood::TestCase
  def setup
    super

    @comment = FactoryGirl.create(:comment)
    @entity = FactoryGirl.create(:entity, :entityable_id => @comment.id)
    @comment = CommentDecorator.decorate(@comment)
  end

  context "comment" do
    test "reveal the underlying comment" do
      assert_equal @comment.object.comment, @comment.comment
    end
  end
end

