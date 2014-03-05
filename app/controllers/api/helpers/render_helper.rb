module Api::Helpers::RenderHelper
  private
    def render_success(*args)
      respond_to do |format|
        format.json { render *args }
      end
    end

    def render_paginated_index(entries)
      entries = entries.paginate(@pagination_options).decorate
      render json: entries, meta: entries.meta
    end

    def render_error(error, options = {})
      render json: error, :status => error.http_error
    end
end

