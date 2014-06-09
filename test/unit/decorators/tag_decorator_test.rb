class TagDecoratorTest < DoGood::TestCase
  def setup
    super

    @tag = FactoryGirl.create(:tag).decorate
  end

  test "tag name" do
    assert_equal @tag.object.title, @tag.name
  end

  test "tag link" do
    assert_equal "dogood://goods/tagged/#{@tag.object.title}", @tag.link
  end
end

