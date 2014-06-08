require 'test_helper'

class CommentTest < DoGood::TestCase
  class CommentValidations < DoGood::TestCase
    test "should be valid with all default values" do
      assert FactoryGirl.build(:comment).valid?
    end

    test "should have a message" do
      assert FactoryGirl.build(:comment).valid?
      refute FactoryGirl.build(:comment, comment: "").valid?
    end

    test "should not be too long" do
      assert FactoryGirl.build(:comment).valid?
      refute FactoryGirl.build(:comment, :too_long).valid?
    end

    test "should have a user" do
      assert FactoryGirl.build(:comment, user_id: 5).valid?
      refute FactoryGirl.build(:comment, user_id: "").valid?
    end

    test "should not be too short" do
      refute FactoryGirl.build(:comment, :too_short).valid?
    end
  end

  class CommentArrays < DoGood::TestCase
    test "should return all comments for a specific good" do
      good = FactoryGirl.create(:good)

      FactoryGirl.create(
        :comment,
        commentable_id: good.id,
        commentable_type: "Good")
      FactoryGirl.create(
        :comment,
        commentable_id: good.id,
        commentable_type: "Good")

      assert_equal 2, Comment.for_good(good.id).count
    end
  end
end
