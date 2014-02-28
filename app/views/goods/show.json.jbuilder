
dapi_callback_wrapper_new_style(json, {
  :status_code => @status_code,
  :response_status => @response_status
}) do

  json.goods do
    GoodDecorator.decorate(@good, :context => {
      :json => json
    }).to_builder
  end
end

