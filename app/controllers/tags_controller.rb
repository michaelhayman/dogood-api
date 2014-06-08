class TagsController < ApiController
  before_filter :setup_pagination, only: [
    :popular, :search
  ]

  def search
    @tags = Tag.matching(params[:q])
    @tags = Tag.popular unless @tags.present?
    render_paginated_index(@tags)
  end

  def popular
    @pagination_options = @pagination_options.merge({
      total_entries: 10
    })
    @tags = Tag.popular
    render_paginated_index(@tags)
  end
end

