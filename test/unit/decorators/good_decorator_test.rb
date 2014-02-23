require 'test_helper'

class GoodDecoratorTest < DoGood::TestCase
  def setup
    super
    @user = FactoryGirl.create(:user)
    @good_1 = GoodDecorator.decorate(FactoryGirl.create(:good, :user => @user))
    @comment_1 = FactoryGirl.create(:comment, :for_good, user: @user, commentable_id: @good_1.id)

    @good_2 = GoodDecorator.decorate(FactoryGirl.create(:good))
  end

  context "current_user_commented" do
    xtest "that the current user commented on the right good" do
      # TODO: lrn to mock
    end
  end
end
