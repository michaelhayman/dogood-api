class CommentsController < ApiController
  before_filter :setup_pagination, only: [ :index ]

  def index
    @comments = Comment.
      for_good(params[:good_id]).
      includes(:user, :entities)

    render_paginated_index(@comments)
  end

  def create
    check_auth
    @comment = Comment.new(resource_params)
    @comment.user_id = current_user.id

    if @comment.save
      render json: @comment.decorate, root: "comments"
    else
      message = @comment.errors.full_messages.first || "Couldn't save comment."
      raise DoGood::Api::RecordNotSaved.new(message)
    end
  end

  def resource_params
    params.require(:comment).permit(
      :commentable_id,
      :commentable_type,
      :comment,
      :user_id,
      entities_attributes: [
        :link_id,
        :link_type,
        :title,
        range: []
    ])
  end
  private :resource_params
end

