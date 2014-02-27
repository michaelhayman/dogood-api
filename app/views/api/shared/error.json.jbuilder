
dapi_callback_wrapper_new_style(json, {
  :status_code => error.http_error,
  :response_status => @response_status
}) do
  json.errors do
    json.http_status error.http_error
    json.dg_status error.dg_error
    json.error_class error.class.to_s
    json.description error.dg_message
  end
end

