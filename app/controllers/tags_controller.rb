class TagsController < ApiController
  before_filter :setup_pagination, :only => [
    :index, :search, :popular
  ]
  def index
    @tags = Tag.all.limit(20)
    @tags = @tags.paginate(@pagination_options)
    render_success
  end

  def search
    hashtag = Tag.arel_table
    if params[:q] != "(null)" && params[:q] != nil
      @tags = Tag.
        where(hashtag[:name].matches("%#{params[:q]}%")).
        limit(10)
    else
      @tags = Tag.limit(10)
    end
    @tags = @tags.paginate(@pagination_options)
    render_success('index')
  end

  def popular
    @tags = Tag.popular
    @tags = @tags.paginate(@pagination_options)
    render_success('index')
  end
end

