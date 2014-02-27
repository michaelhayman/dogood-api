
dapi_callback_wrapper_new_style(json, {
  :status_code => @status_code,
  :response_status => @response_status
}) do

  json.(
    @comments,
      :current_page,
      :total_pages,
      :per_page
  )

  json.total_results @comments.count

  json.comments do
    json.array!(CommentJSONDecorator.decorate_collection(@comments, :context => {
      :json => json
    })) do |comment|
      comment.to_builder
    end
  end
end
