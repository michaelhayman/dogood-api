module Api::Helpers::RenderHelper
  private
    def render_paginated_index(entries, serializer = nil, root = nil)
      entries = entries.paginate(@pagination_options).decorate
      if serializer.present? && serializer.is_a?(Class) && serializer.superclass.name == "ActiveModel::Serializer"
        render json: entries, meta: entries.meta, each_serializer: serializer, root: root
      else
        render json: entries, meta: entries.meta, root: root
      end
    end

    def render_index(entries)
      render json: entries.decorate
    end

    def render_ok
      render json: { }, status: :ok
    end

    def render_error(error, options = {})
      render json: {
        errors: {
          messages: Array.wrap(error.message)
        }
      }, status: error.http_error
    end
end

