class UnsubscribesController < ApiController
  def opt_out
    if Unsubscribe.find_or_create_by(email: resource_params[:email])
      render_ok
    else
      render_error(DoGood::Api::ParametersInvalid.new("Opt out failed."))
    end
  end

  def resource_params
    params.require(:unsubscribe).permit(:email)
  end
  private :resource_params
end
