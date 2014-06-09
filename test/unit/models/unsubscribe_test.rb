class UnsubscribeTest < DoGood::TestCase
  test "opt out returns the correct value" do
    Unsubscribe.create(email: "hi@hi.com")
    assert Unsubscribe.opted_out?("hi@hi.com")
    refute Unsubscribe.opted_out?("hi@bye.com")
  end
end
