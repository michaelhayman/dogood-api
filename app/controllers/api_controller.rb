class ApiController < ApplicationController
  include Api::Helpers::RenderHelper

  require 'do_good/api/error'
  require 'will_paginate/array'

  DEFAULT_PAGINATION_OPTIONS = {
    :per_page => 25
  }.freeze

  def setup_pagination
    @pagination_options = DEFAULT_PAGINATION_OPTIONS.merge({
      :per_page => params[:per_page],
      :page => [ params[:page].to_i, 1 ].max
    })
  end
end

