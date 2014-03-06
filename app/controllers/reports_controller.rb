class ReportsController < ApiController
  before_filter :check_auth, only: [ :create ]

  def create
    @report = Report.new(resource_params)
    @report.user_id = current_user.id

    if @report.save!
      render json: @report, root: "reports"
    else
      render_errors(DoGood::Api::RecordNotSaved.new("Couldn't save the report. #{@report.errors.full_messages.first}"))
    end
  end

  def resource_params
    params.require(:report).permit(:reportable_type, :reportable_id)
  end
  private :resource_params
end
