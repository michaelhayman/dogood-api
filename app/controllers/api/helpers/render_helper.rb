# encoding: UTF-8

module Api::Helpers::RenderHelper
  private
    def render_success(*args)
      respond_to do |format|
        format.json { render *args }
      end
    end

    def render_error(error, options = {})
      path = "/api/shared/error"

      render(
        path,
        :layout => false,
        :status => error.http_error,
        :locals => {
          :error => error
        }
      )
    end
end

