class HomeController < ApplicationController
  def index
    @categories = Category.all.decorate
    @goods = Good.popular.all.decorate
    @tags = Tag.popular.decorate
  end
end

