class BookmarksController < ApplicationController
  before_action :authenticate_user!

  def index
    @bookmarks = current_user.bookmarks.includes(:post).order(created_at: :desc).page(params[:page]).per(6)
    @posts = @bookmarks.map(&:post).compact
  end

  def create
    @post = Post.find(params[:post_id])
    @bookmark = current_user.bookmarks.new(post: @post)
    if @bookmark.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_back fallback_location: posts_path }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("bookmark_buttons_#{@post.id}", partial: "bookmarks/bookmark_buttons", locals: { post: @post }) }
        format.html { redirect_back fallback_location: posts_path }
      end
    end
  end

  def destroy
    @bookmark = current_user.bookmarks.find_by(id: params[:id])
    if @bookmark&.destroy
      @post = @bookmark.post
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_back fallback_location: posts_path }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("bookmark_buttons_#{@bookmark.post.id}", partial: "bookmarks/bookmark_buttons", locals: { post: @bookmark.post }) }
        format.html { redirect_back fallback_location: posts_path }
      end
    end
  end
end
