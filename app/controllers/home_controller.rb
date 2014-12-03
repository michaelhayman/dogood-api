class HomeController < ApplicationController
  def index
    @categories = Category.all.decorate
    @goods = Good.popular.decorate
    @goods = Good.all.decorate
    @tags = Tag.popular.decorate
  end
end

