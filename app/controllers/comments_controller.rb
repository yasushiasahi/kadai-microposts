class CommentsController < ApplicationController
  def create
    if params[:content] == "open comments field"
      session[:micropost_id] = params[:micropost_id]
      redirect_back(fallback_location: root_path)
    else
      comment = current_user.comments.build(comment_params)
      comment.micropost_id = params[:micropost_id]
      if comment.save
        flash[:success] = "コメントを投稿しました。"
        redirect_back(fallback_location: root_path)
      else
        flash[:danger] = "コメントの投稿に失敗しました。"
        render "toppages/index"
      end
    end
  end

  def destroy
    correct_user
    @comment.destroy
    flash[:success] = "コメントを削除しました"
    redirect_back(fallback_location: root_path)
  end
  
  
  
  private 
  
  def comment_params
    params.require(:comment).permit(:content)
  end
  
  def correct_user
    @comment = current_user.comments.find_by(id:params[:id])
    unless @comment
      redirect_back(fallback_location: root_path)
    end
  end
  
end
