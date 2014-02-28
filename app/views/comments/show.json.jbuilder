
dapi_callback_wrapper_new_style(json, {
  :status_code => @status_code,
  :response_status => @response_status
}) do
  json.comments CommentDecorator.decorate(@comment).to_builder
end

