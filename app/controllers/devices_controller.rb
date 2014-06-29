class DevicesController < ApiController
  def update
    if current_user
      @device = Device.find_or_initialize_by(token: params[:id])
      @device.user = current_user
      @device.provider = "apns"
      @device.is_valid = true

      if @device.save
        render_ok
      else
        error = @device.errors.first
        render_error(DoGood::Api::ParametersInvalid.new(error))
      end
    else
      render_error(DoGood::Api::Unauthorized.new)
    end
  end

  def destroy
    if current_user
      @device = Device.find_by_token(params[:id])

      if @device.destroy
        render_ok
      else
        error = @device.errors.first
        render_error(DoGood::Api::ParametersInvalid.new(error))
      end
    else
      render_error(DoGood::Api::Unauthorized.new)
    end
  end

  def device_params
    params.require(:device).permit(:token)
  end
  private :device_params
end

