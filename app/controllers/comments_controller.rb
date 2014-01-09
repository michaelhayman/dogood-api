class CommentsController < ApplicationController
  before_filter :check_auth, only: [ :create ]

  def index
    @comments = Comment.
      for_good(params[:good_id]).
      page(params[:page]).
      includes(:user, :entities)
    respond_with @comments,
      each_serializer: CommentSerializer
  end

  def create
    @comment = Comment.new(resource_params)
    @comment.user_id = current_user.id

    if @comment.save
      render :json => @comment, root: "comments"
      # respond_with @comment, root: "comments"
    else
      if @comment.errors
        message = @comment.errors.full_messages
      else
        message = "Couldn't save the comment."
      end
      render_errors(message)
    end
  end

  def resource_params
    params.require(:comment).permit(:commentable_id, :commentable_type, :comment, :user_id, :entities_attributes => [ :entityable_id, :entityable_type, :link, :link_id, :link_type, :title, :range => [] ])
  end
  private :resource_params
end

