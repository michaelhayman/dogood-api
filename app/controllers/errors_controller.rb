class ErrorsController < ApiController
  def not_found
    respond_to do |format|
      format.html
      format.json {
        raise DoGood::Api::RecordNotFound.new
      }
    end
  end

  def exception
    respond_to do |format|
      format.html
      format.json {
        raise DoGood::Api::RecordNotSaved.new
      }
    end
  end
end

