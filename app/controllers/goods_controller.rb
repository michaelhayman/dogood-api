class GoodsController < ApplicationController
  def index
    @goods = Good.in_category(1).by_user(1).stream(current_user)

    respond_with @goods
  end
end

