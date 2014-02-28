require 'test_helper'

class GoodJSONDecoratorTest < DoGood::TestCase
  def expected_hash
    good = @good.object
    {
      "id" => good.id,
      "caption" => good.caption,
      "current_user_commented" => @good.current_user_commented,
      "current_user_regooded" => @good.current_user_regooded,
      "current_user_liked" => @good.current_user_liked,
      "comments" => @good.comments,
      "comments_count" => good.comments_count,
      "created_at"=> good.created_at,
      "done" => @good.done,
      "entities" => @good.entities,
      "evidence" => @good.evidence,
      "likes_count" => @good.likes_count,
      "lng" => @good.lng,
      "lat" => @good.lat,
      "location_image" => @good.location_name,
      "location_name" => @good.location_name,
      "nominee" => {
        "user_id" => @good.nominee.user_id,
        "full_name" => @good.nominee.full_name
      },
      "regoods_count" => @good.regoods_count,
      "user" => {
        "id"=> good.user.id,
        "full_name" => good.user.full_name
      }
    }
  end

  def setup
    super

    Timecop.freeze(Time.local(2013))

    @good = FactoryGirl.create(:good)
    @good = GoodJSONDecorator.decorate(@good)
    stub(@good).current_user_commented { true }
    stub(@good).current_user_liked { true }
    stub(@good).current_user_regooded { false }
  end

  context "to_builder" do
    test "with defaults" do
      json = JSON.load(@good.to_builder.target!)
      assert_hashes_equal(expected_hash, json)
    end
  end
end

