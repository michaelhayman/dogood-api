class ReportsController < ApiController
  def create
    check_auth
    raise DoGood::Api::ParametersInvalid.new("No parameters.") if !params[:report].present?

    @report = Report.new(resource_params)
    @report.user_id = current_user.id

    raise DoGood::Api::ParametersInvalid.new(default_message) if @report.invalid?

    if @report.save
      render_ok
    else
      raise DoGood::Api::RecordNotSaved.new(default_message)
    end
  end

  def resource_params
    params.require(:report).permit(:reportable_type, :reportable_id)
  end
  private :resource_params

  private
    def default_message(msg = "Couldn't file report.")
      @report.errors.full_messages || msg
    end
end
