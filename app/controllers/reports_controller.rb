class ReportsController < ApplicationController
  def create
    @report = Report.new(resource_params)
    @report.user_id = current_user.id

    if @report.save!
      respond_with @report, root: "reports"
    else
      render_errors("Couldn't save the report. #{@report.errors}")
    end
  end

  def resource_params
    params.require(:report).permit(:reportable_type, :reportable_id)
  end
  private :resource_params
end
