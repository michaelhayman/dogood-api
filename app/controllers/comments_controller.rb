class CommentsController < ApiController
  def index
    setup_pagination

    @comments = Comment.
      for_good(params[:good_id]).
      includes(:user, :entities).
      paginate(@pagination_options)
  end

  def create
    begin
      raise DoGood::Api::Unauthorized.new if !logged_in?
      @comment = Comment.new(resource_params)
      @comment.user_id = current_user.id

      if @comment.save
        render_success("show")
      else
        if @comment.errors
          message = @comment.errors.full_messages
        else
          message = "Couldn't save the comment."
        end
        raise DoGood::Api::RecordNotSaved.new(message)
      end

    rescue DoGood::Api::RecordNotSaved => error
      render_error(error)
      return
    end
  end

  def resource_params
    params.require(:comment).permit(:commentable_id, :commentable_type, :comment, :user_id, :entities_attributes => [ :entityable_id, :entityable_type, :link, :link_id, :link_type, :title, :range => [] ])
  end
  private :resource_params
end

