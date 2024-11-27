class LikesController < ApplicationController
  before_action :authenticate_user!

  def index
    @likes = current_user.likes.includes(:post).order(created_at: :desc).page(params[:page]).per(6)
    @posts = @likes.map(&:post).compact
  end

  def create
    @post = Post.find(params[:post_id])
    like = current_user.likes.new(post: @post)
    if like.save
      redirect_back fallback_location: posts_path, notice: "いいねしました"
    else
      redirect_back fallback_location: posts_path, alert: "いいねに失敗しました: #{like.errors.full_messages.to_sentence}"
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    like = current_user.likes.find_by(post: @post)
    if like&.destroy
      redirect_back fallback_location: posts_path, notice: "いいねを解除しました"
    else
      redirect_back fallback_location: posts_path, alert: "いいねの解除に失敗しました"
    end
  end
end
