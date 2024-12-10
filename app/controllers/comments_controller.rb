class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user # 現在のユーザーをコメントの作成者として設定

    if @comment.save
      redirect_to post_path(@post)
    else
      redirect_to post_path(@post), alert: "コメントの追加に失敗しました。"
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
