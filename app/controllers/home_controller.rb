class HomeController < ApplicationController
  def index
    @categories = Category.all.decorate
    @goods = Good.extra_info.all.decorate
    @tags = Tag.popular.decorate
  end
end

