class TagsController < ApiController
  def index
    @tags = Tag.full_list.decorate
  end

  def search
    @tags = Tag.matching(params[:q])
    render_index(@tags)
  end

  def popular
    @tags = Tag.popular
    render_index(@tags)
  end
end

