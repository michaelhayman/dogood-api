class TagsController < ApiController
  before_filter :setup_pagination, only: [
    :index, :search, :popular
  ]
  def index
    @tags = Tag.all.limit(20)
    render_paginated_index(@tags)
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
    render_paginated_index(@tags)
  end

  def popular
    @tags = Tag.popular
    render_paginated_index(@tags)
  end
end

