class CommentTest < DoGood::TestCase
  test "should be valid with all default values" do
    assert FactoryGirl.build(:comment).valid?
  end

  test "should have a message" do
    assert FactoryGirl.build(:comment).valid?
    refute FactoryGirl.build(:comment, comment: "").valid?
  end

  test "should not be too long" do
    assert FactoryGirl.build(:comment).valid?
    refute FactoryGirl.build(:comment, :too_long).valid?
  end

  test "should have a user" do
    assert FactoryGirl.build(:comment, user_id: 5).valid?
    refute FactoryGirl.build(:comment, user_id: "").valid?
  end

  test "should not be too short" do
    refute FactoryGirl.build(:comment, :too_short).valid?
  end

  test "should return all comments for a specific good" do
    good = FactoryGirl.create(:good)

    FactoryGirl.create(
      :comment,
      commentable_id: good.id,
      commentable_type: "Good")
    FactoryGirl.create(
      :comment,
      commentable_id: good.id,
      commentable_type: "Good")

    assert_equal 2, Comment.for_good(good.id).count
  end

  test "send notification for comment" do
    @bob = FactoryGirl.create(:user, :bob)
    @tony = FactoryGirl.create(:user, :tony)
    @good = FactoryGirl.create(:good, user: @tony)
    @comment = FactoryGirl.create(:comment, user: @bob, commentable: @good)
    stub(NotifierWorker).perform_async { true }
    @comment.send_notification
    message = "#{@bob.full_name} posted a new comment on your post"
    url = "dogood://goods/#{@good.id}"
    assert_received(NotifierWorker) { |o| o.perform_async(message, @tony.id, { url: url }) }
  end
end
