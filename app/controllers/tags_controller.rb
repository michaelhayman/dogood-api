class TagsController < ApplicationController
  def index
    @hashtags = SimpleHashtag::Hashtag.all.limit(20)
  end

  def search
    hashtag = SimpleHashtag::Hashtag.arel_table
    if params[:q] != "(null)"
      @hashtags = SimpleHashtag::Hashtag.
        where(hashtag[:name].matches("%#{params[:q]}%")).
        limit(10)
    else
      @hashtags = SimpleHashtag::Hashtag.all
    end
    respond_with @hashtags, each_serializer: TagSerializer
  end

  def popular
    @hashtags = SimpleHashtag::Hashtagging.select(:hashtag_id, :name, :created_at).joins(:hashtag).distinct.order('created_at desc').limit(10)
    respond_with @hashtags, each_serializer: TagSerializer
  end
end

