
dapi_callback_wrapper_new_style(json, {
  :status_code => @status_code,
  :response_status => @response_status
}) do

  json.(
    @tags,
      :current_page,
      :total_pages,
      :per_page
  )

  json.total_results @tags.count

  json.tags do
    json.array!(TagDecorator.decorate_collection(@tags, :context => {
      :json => json
    })) do |tag|
      tag.to_builder
    end
  end
end
