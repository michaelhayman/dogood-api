require 'test_helper'

class CommentDecoratorTest < DoGood::TestCase
  def expected_hash
    comment = @comment.object
    {
      "comment" => comment.comment
    }
  end

  def setup
    super

    @comment = FactoryGirl.create(:comment)
    @comment = CommentDecorator.decorate(@comment)
  end

  context "to_builder" do
    test "with defaults" do
      json = JSON.load(@comment.to_builder.target!)
      assert_hashes_equal(expected_hash, json)
    end
  end
end

