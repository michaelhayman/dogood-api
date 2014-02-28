
dapi_callback_wrapper_new_style(json, {
  :status_code => @status_code,
  :response_status => @response_status
}) do
  json.tags TagDecorator.decorate(@tag).to_builder
end

