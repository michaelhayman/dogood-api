require 'test_helper'

class InviteMailerTest < DoGood::TestCase
  def setup
    super

    @nominee = FactoryGirl.build(:nominee)
  end

  test "send invite" do
    @email = InviteMailer.invite_nominee(@nominee).deliver

    refute ActionMailer::Base.deliveries.empty?
    assert_match(/You've been nominated at Do Good/, @email.encoded)
    assert_equal [ @nominee.email ], @email.to
  end
end


