class CategoriesController < ApplicationController
  def index
    @categories = Category.all
    expires_in 24.hours, :public => true
    if stale? :etag => @categories,
              :last_modified => @categories.maximum(:updated_at),
              :public => true
      respond_with @categories, each_serializer: CategorySerializer
    end
  end
end

