require 'test_helper'

class NomineeSerializerTest < DoGood::TestCase
  def expected_hash
    {
      nominees: {
        full_name: @nominee.full_name,
        avatar_url: @nominee.avatar_url
      }
    }
  end

  def setup
    super
    @nominee = FactoryGirl.create(:nominee).decorate

    @serializer = NomineeSerializer.new @nominee, root: "nominees"
  end

  test "api" do
    assert_equal expected_hash.to_json, @serializer.to_json
  end
end

