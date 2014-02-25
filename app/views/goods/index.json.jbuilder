
dapi_callback_wrapper_new_style(json, {
  :status_code => @status_code,
  :response_status => @response_status
}) do

  json.(
    @goods,
      :current_page,
      :total_pages,
      :per_page
  )

  json.total_results @goods.count

  json.goods do
    json.array!(GoodJSONDecorator.decorate_collection(@goods, :context => {
      :json => json,
      :host => request.host_with_port
    })) do |good|
      good.to_builder
    end
  end
end

