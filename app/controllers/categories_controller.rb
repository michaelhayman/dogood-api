class CategoriesController < ApplicationController
  def index
    @categories = Category.alphabetical
    expires_in 24.hours, :public => true
    if stale? :etag => @categories,
              :last_modified => @categories.maximum(:updated_at),
              :public => true
      render json: @categories
    end
  end
end

