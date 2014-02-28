class TagsController < ApiController
  before_filter :setup_pagination, :only => [
    :index, :search, :popular
  ]
  def index
    @tags = SimpleHashtag::Hashtag.all.limit(20)
    @tags = @tags.paginate(@pagination_options)
    render_success
  end

  def search
    hashtag = SimpleHashtag::Hashtag.arel_table
    if params[:q] != "(null)"
      @tags = SimpleHashtag::Hashtag.
        where(hashtag[:name].matches("%#{params[:q]}%")).
        limit(10)
    else
      @tags = SimpleHashtag::Hashtag.all
    end
    @tags = @tags.paginate(@pagination_options)
    render_success('index')
  end

  def popular
    @tags = SimpleHashtag::Hashtagging.select(:hashtag_id, :name, :created_at).joins(:hashtag).distinct.order('created_at desc').limit(10)
    @tags = @tags.paginate(@pagination_options)
    render_success('index')
  end
end

