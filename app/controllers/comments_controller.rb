class CommentsController < ApiController
  before_filter :setup_pagination, :only => [ :index ]
  before_filter :check_auth, :only => [ :create ]

  def index
    @comments = Comment.
      for_good(params[:good_id]).
      includes(:user, :entities)

    render_paginated_index(@comments)
  end

  def create
    begin
      @comment = Comment.new(resource_params)
      @comment.user_id = current_user.id

      if @comment.save
        render json: @comment, root: "comments"
      else
        message = @comment.errors.full_messages.first || "Couldn't save comment."
        raise DoGood::Api::RecordNotSaved.new(message)
      end

    rescue DoGood::Api::RecordNotSaved => error
      render_error(error)
      return
    end
  end

  def resource_params
    params.require(:comment).permit(
      :commentable_id,
      :commentable_type,
      :comment,
      :user_id,
      :entities_attributes => [
        :entityable_id,
        :entityable_type,
        :link,
        :link_id,
        :link_type,
        :title,
        :range => []
    ])
  end
  private :resource_params
end

