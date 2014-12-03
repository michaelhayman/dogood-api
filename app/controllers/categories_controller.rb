class CategoriesController < ApplicationController
  def index
    @categories = Category.alphabetical
    expires_in 24.hours, public: true
    if stale? etag: @categories,
              last_modified: @categories.maximum(:updated_at),
              public: true
      render json: @categories.decorate
    end
  end

  def show
    @category = Category.friendly.find(params[:id])

    @goods = Good.in_category(@category.id).decorate
  end
end

