require 'test_helper'

class NomineeDecoratorTest < DoGood::TestCase
  def setup
    super

    @nominee = FactoryGirl.create(:nominee)
    @nominee = NomineeDecorator.decorate(@nominee)
  end

  test "avatar" do
    assert_equal "", @nominee.avatar_url
  end
end

