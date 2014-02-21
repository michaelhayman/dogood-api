# encoding: UTF-8

require 'test_helper'

class CurrentUserDecoratorTest < DoGood::TestCase
  context "a user's saved data" do
    def setup
      super

      @user = CurrentUserDecorator.decorate(FactoryGirl.create(:user))

      @good = FactoryGirl.create(:good)
      @comment_1 = FactoryGirl.create(:comment, :for_good, user: @user.object, commentable_id: @good.id)

      @good_2 = FactoryGirl.create(:good)
      @comment_2 = FactoryGirl.create(:comment, :for_good, user: @user.object, commentable_id: @good_2.id)

      @good_3 = FactoryGirl.create(:good)

      @good_ids = [
        @good.id, @good_2.id, @good_3.id
      ]
    end

    context "commented_good_ids" do
      def setup
        super

      end

      test "should contain only the commented IDs" do
        assert_equal [ @good_2.id, @good.id ], @user.commented_good_ids
        assert Good.all.count > @user.commented_good_ids.count
      end
    end

    context "good_commented?" do
      test "should be true for a commented good" do
        assert(@user.good_commented?(@good), "should accept a good itself")
        assert(@user.good_commented?(@good.id), "should accept a good id")
      end

      test "should be false for a good which isn't liked" do
        refute(@user.good_commented?(@good_3), "should accept good itself")
        refute(@user.good_commented?(@good_3.id), "should accept a good id")
      end
    end

    context "regooded_good_ids" do
    end

    context "liked_good_ids" do
    end
  end
end
