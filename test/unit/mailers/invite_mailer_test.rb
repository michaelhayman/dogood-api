require 'test_helper'

class InviteMailerTest < DoGood::TestCase
  def setup
    super

    @nominee = FactoryGirl.build(:nominee)
    @nominator = FactoryGirl.build(:user)
  end

  test "send invite" do
    @email = InviteMailer.invite_nominee(@nominee, @nominator).deliver

    refute ActionMailer::Base.deliveries.empty?
    assert_match(/You've been nominated/, @email.encoded)
    assert_equal [ @nominee.email ], @email.to
  end

  test "don't send invite if no email address is present" do
    nominee = @nominee
    nominee.email = nil
    @email = InviteMailer.invite_nominee(nominee, @nominator).deliver

    assert ActionMailer::Base.deliveries.empty?
  end
end


