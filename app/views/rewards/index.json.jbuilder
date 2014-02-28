
dapi_callback_wrapper_new_style(json, {
  :status_code => @status_code,
  :response_status => @response_status
}) do

  json.(
    @rewards,
      :current_page,
      :total_pages,
      :per_page
  )

  json.total_results @rewards.count

  json.rewards do
    json.array!(RewardDecorator.decorate_collection(@rewards, :context => {
      :json => json
    })) do |reward|
      reward.to_builder
    end
  end
end
