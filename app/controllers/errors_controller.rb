class ErrorsController < ApiController
  def not_found
    raise DoGood::Api::RecordNotFound.new
  end

  def exception
    raise DoGood::Api::RecordNotSaved.new
  end
end

