class GoodSerializer < ActiveModel::Serializer
  attributes :caption
end

class GoodsController < ApplicationController
  # before_filter :authenticate_user!

  def index
    authenticate_user!
    @users = User.all
  end
end

