
dapi_callback_wrapper_new_style(json, {
  :status_code => @status_code,
  :response_status => @response_status
}) do

  json.(
    @users,
      :current_page,
      :total_pages,
      :per_page
  )

  json.total_results @users.count

  json.users do
    json.array!(UserJSONDecorator.decorate_collection(@users, :context => {
      :json => json
    })) do |user|
      user.to_builder
    end
  end
end
