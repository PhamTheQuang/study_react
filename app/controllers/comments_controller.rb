class CommentsController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json { render json: Comment.all, status: :ok }
    end
  end

  def create
    @comment = Comment.new(comment_params)
    respond_to do |format|
      if @comment.save
        format.html
        format.json { render json: @comment, status: :ok }
      else
        format.json { render json: {}, status: :unprocessable_entity }
      end
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:author, :content)
  end
end
