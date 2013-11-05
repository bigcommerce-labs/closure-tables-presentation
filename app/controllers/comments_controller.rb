class CommentsController < ApplicationController

  def index
    params[:parent] ||= 0
    @time_to_fetch = Benchmark.measure {
      @comments = Comment.fetch(params[:parent])
    }
    @comment = Comment.new

    if params[:delete]
      delete_comment(params[:delete])
    end
  end

  def delete_comment(id)
    @comment = Comment.find(id)
    if @comment and @comment.destroy
      redirect_to comments_path, notice: 'Comment was successfully deleted.'
    else
      render action: :index
    end
  end

  def new
    @comment = Comment.new
  end

  def create
    @comment = Comment.create(comment_params)
    if @comment
      redirect_to comments_path, notice: 'Comment was successfully created.'
    else
      render action: :index
    end

  end

  protected

  def comment_params
    params.require(:comment).permit(:author,:body,:thread_key,:parent_id)
  end
end
