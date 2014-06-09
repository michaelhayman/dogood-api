class TagsController < ApiController
  def search
    @tags = Tag.matching(params[:q])
    render_index(@tags)
  end

  def popular
    @tags = Tag.popular
    render_index(@tags)
  end
end

