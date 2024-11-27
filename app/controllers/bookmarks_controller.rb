class BookmarksController < ApplicationController
  before_action :authenticate_user!

  def index
    @bookmarks = current_user.bookmarks.includes(:post).order(created_at: :desc).page(params[:page]).per(6)
    @posts = @bookmarks.map(&:post).compact
  end

  def create
    @post = Post.find(params[:post_id])
    bookmark = current_user.bookmarks.new(post: @post)
    if bookmark.save
      redirect_back fallback_location: posts_path, notice: "ブックマークしました"
    else
      redirect_back fallback_location: posts_path, alert: "ブックマークに失敗しました: #{bookmark.errors.full_messages.to_sentence}"
    end
  end

  def destroy
    bookmark = current_user.bookmarks.find_by(id: params[:id])
    if bookmark&.destroy
      redirect_back fallback_location: posts_path, notice: "ブックマークを解除しました"
    else
      redirect_back fallback_location: posts_path, alert: "ブックマークの解除に失敗しました"
    end
  end  
end