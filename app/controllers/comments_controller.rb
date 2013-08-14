class CommentsController < ApplicationController
  def index
    @comments = Comment.for_good(params[:good_id]).unlimited
    respond_with @comments
  end

  def create
    @comment = Comment.new(resource_params)

    if @comment.save
      render :json => @comment, root: "comments"
      # respond_with @comment, root: "comments"
    else
      render_errors("Couldn't save the comment.")
    end
  end

  def resource_params
    params.require(:comment).permit(:commentable_id, :commentable_type, :comment, :user_id)
  end
  private :resource_params
end

