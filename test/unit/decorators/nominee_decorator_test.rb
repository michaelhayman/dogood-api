require 'test_helper'

class NomineeDecoratorTest < DoGood::TestCase
  def setup
    super

    @nominee = FactoryGirl.create(:nominee)
    @nominee = NomineeDecorator.decorate(@nominee)
  end

  context "avatar" do
    test "avatar" do
      assert_equal "hey", @nominee.avatar_url
    end
  end
end

