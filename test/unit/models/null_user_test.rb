class NullUserTest < DoGood::TestCase
  def setup
    super

    @user = NullUser.new
  end

  test "first name" do
    assert_equal('Guest', @user.first_name)
  end

  test "email" do
    refute(@user.email)
  end

  test "signed_in" do
    refute(@user.logged_in?)
  end

  test "nonsensical method name" do
    refute(@user.nonsensical_method_name)
  end
end

