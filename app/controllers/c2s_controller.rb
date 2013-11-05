class C2sController < ApplicationController

  def index
    params[:parent] ||= 0
    @time_to_fetch =
    @comments = C2.fetch(params[:parent])
    @comment = C2.new

    if params[:delete]
      delete_comment(params[:delete])
    end
  end

  def delete_comment(id)
    @comment = C2.find(id)
    if @comment and @comment.destroy
      redirect_to c2s_path, notice: 'Comment was successfully deleted.'
    else
      render action: :index
    end
  end

  def new
    @comment = C2.new
  end

  def create
    @comment = C2.create(comment_params)
    if @comment
      redirect_to c2s_path, notice: 'Comment was successfully created.'
    else
      render action: :index
    end

  end

  protected

  def c2_params
    params.require(:c2).permit(:author,:body,:thread_key,:parent_id)
  end
end
