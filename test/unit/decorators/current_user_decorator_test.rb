require 'test_helper'

class CurrentUserDecoratorTest < DoGood::TestCase
  context "a user's saved data" do
    def setup
      super

      @user = CurrentUserDecorator.decorate(FactoryGirl.create(:user))

      @good = FactoryGirl.create(:good)
      @comment_1 = FactoryGirl.create(:comment, :for_good, user: @user.object, commentable_id: @good.id)
      @user.follow(@good)
      @good.liked_by @user.object

      @good_2 = FactoryGirl.create(:good)
      @comment_2 = FactoryGirl.create(:comment, :for_good, user: @user.object, commentable_id: @good_2.id)
      @user.follow(@good_2)
      @good_2.liked_by @user.object

      @good_3 = FactoryGirl.create(:good)

      @good_ids = [
        @good.id, @good_2.id, @good_3.id
      ]
    end

    context "liked_good_ids" do
      test "should contain only the liked IDs" do
        assert_equal [ @good_2.id, @good.id ], @user.liked_good_ids
        assert Good.all.count > @user.liked_good_ids.count
      end
    end

    context "good_liked?" do
      test "should be true for a liked good" do
        assert(@user.good_liked?(@good), "should accept a good itself")
        assert(@user.good_liked?(@good.id), "should accept a good id")
      end

      test "should be false for a good which isn't liked" do
        refute(@user.good_liked?(@good_3), "should accept good itself")
        refute(@user.good_liked?(@good_3.id), "should accept a good id")
      end
    end

    context "commented_good_ids" do
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
      test "should contain only the regooded IDs" do
        assert_equal [ @good_2.id, @good.id ], @user.regooded_good_ids
        assert Good.all.count > @user.regooded_good_ids.count
      end
    end

    context "good_regooded?" do
      test "should be true for a regooded good" do
        assert(@user.good_regooded?(@good), "should accept a good itself")
        assert(@user.good_regooded?(@good.id), "should accept a good id")
      end

      test "should be false for a good which isn't liked" do
        refute(@user.good_regooded?(@good_3), "should accept good itself")
        refute(@user.good_regooded?(@good_3.id), "should accept a good id")
      end
    end
  end
end
