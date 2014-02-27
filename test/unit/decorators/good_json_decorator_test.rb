require 'test_helper'

# !", "comments"=>[], "comments_count"=>0, "created_at"=>"2013-01-01T05:00:00.000Z", "current_user_commented"=>true, "current_user_liked"=>true, "current_user_regooded"=>false, "done"=>true, "entities"=>[], "evidence"=>nil, "id"=>12605, "lat"=>43.652527, "likes_count"=>0, "lng"=>-79.381961, "location_image"=>nil, "location_name"=>nil, "nominee"=>{"id"=>13549, "full_name"=>"Michael Hayman", "email"=>"ashlee@steuber.info", "phone"=>nil, "user_id"=>nil, "twitter_id"=>nil, "facebook_id"=>nil, "avatar"=>{"url"=>nil}}, "regoods_count"=>0, "user"=>{"id"=>14458, "email"=>"ana@towne.com", "created_at"=>"2013-01-01T05:00:00.000Z", "updated_at"=>"2013-01-01T05:00:00.000Z", "avatar"=>{"url"=>nil}, "follows_count"=>0, "full_name"=>"Tony", "phone"=>nil, "points_cache"=>0, "location"=>nil, "biography"=>nil, "facebook_id"=>nil, "twitter_id"=>nil}}

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
      "nominee"=> {
        "user_id" => @good.nominee.user_id,
        "full_name" => @good.nominee.full_name
      },
      "regoods_count"=> @good.regoods_count,
      "user"=> {
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

