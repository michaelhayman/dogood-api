class NomineeDecoratorTest < DoGood::TestCase
  def setup
    super

    @nominee = FactoryGirl.create(:nominee)
    @nominee = NomineeDecorator.decorate(@nominee)
  end

  test "avatar" do
    assert_equal nil, @nominee.avatar_url
  end
end

