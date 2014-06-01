require 'test_helper'

class InviteMailerTest < DoGood::TestCase
  def setup
    super

    @good = FactoryGirl.build(:nominee, :done)
  end

  test "send invite" do
    @email = InviteMailer.invite_nominee(@good).deliver

    refute ActionMailer::Base.deliveries.empty?
    assert_match(/You've been nominated/, @email.encoded)
    assert_equal [ @good.nominee.email ], @email.to
  end

  test "don't send invite if no email address is present" do
    nominee = @good.nominee
    nominee.email = nil
    @email = InviteMailer.invite_nominee(@good).deliver

    assert ActionMailer::Base.deliveries.empty?
  end
end


