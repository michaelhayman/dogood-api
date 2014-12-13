class GoodSerializerTest < DoGood::TestCase
  def expected_hash
    @comment = @good.comments.first
    @entity = @good.entities.first
    {
      goods: {
        id: @good.id,
        caption: @good.caption,
        votes_count: @good.votes_count,
        comments_count: @good.comments_count,
        followers_count: @good.followers_count,
        lat: @good.lat,
        lng: @good.lng,
        location_name: @good.location_name,
        location_image: @good.location_image,
        evidence: @good.evidence,
        done: @good.done,
        created_at: @good.created_at,
        comments: [{
          comment: @comment.comment,
          created_at: @comment.created_at,
          entities: @comment.entities,
          user: {
            id: @comment.user.id,
            slug: @comment.user.slug,
            avatar_url: @comment.user.avatar_url,
            full_name: @comment.user.full_name
          },
        }],
        category: {
          id: @good.category.id,
          name: @good.category.name,
          name_constant: @good.category.name_constant,
          colour: @good.category.colour,
          image_url: @good.category.image_url
        },
        user: {
          id: @good.user.id,
          slug: @good.user.slug,
          avatar_url: @good.user.avatar_url,
          full_name: @good.user.full_name
        },
        entities: [{
          id: @entity.id,
          link: @entity.link,
          link_type: @entity.link_type,
          link_id: @entity.link_id,
          title: @entity.title,
          range: @entity.range
        }],
        nominee: {
          full_name: @good.nominee.full_name,
          avatar_url: @good.nominee.avatar_url
        },
        current_user_voted: @good.current_user_voted,
        current_user_commented: @good.current_user_commented,
        current_user_followed: @good.current_user_followed
      }
    }
  end

  def setup
    super
    @good = FactoryGirl.create(:good, :done)
    @entity = FactoryGirl.create(:entity, entityable_id: @good.id, entityable_type: "Good")
    @comment = FactoryGirl.create(:comment, commentable_id: @good.id, user: @good.user)
    @good = GoodDecorator.decorate(@good)
    stub(@good).current_user_commented { true }
    stub(@good).current_user_voted { true }
    stub(@good).current_user_followed { false }

    @serializer = GoodSerializer.new @good, root: "goods"
  end

  test "outputs standard json for api" do
    assert_equal expected_hash.to_json, @serializer.to_json
  end

  test "defaults cache key" do
    skip "not implemented"
    @serializer = DefaultsSerializer.new @good, root: "goods"
    stub(@serializer).current_user { nil }
    assert_equal @serializer.cache_key, [ @good, @serializer.comment_key, nil ]
  end

  test "current user good cache key" do
    skip "not implemented"
    @serializer = CurrentUserGoodSerializer.new @good, root: "goods"
    stub(@serializer).current_user { nil }
    assert_equal @serializer.cache_key, [ @good.object, @good.current_user_liked, @good.current_user_commented, @good.current_user_regooded, nil ]
  end
end

