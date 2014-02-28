
dapi_callback_wrapper_new_style(json, {
  :status_code => @status_code,
  :response_status => @response_status
}) do
  json.users UserDecorator.decorate(@user).to_builder
end

