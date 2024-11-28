class LikesController < ApplicationController
  before_action :authenticate_user!

  def index
    @likes = current_user.likes.includes(:post).order(created_at: :desc).page(params[:page]).per(6)
    @posts = @likes.map(&:post).compact
  end

  def create
    @post = Post.find(params[:post_id])
    @like = current_user.likes.new(post: @post)
    if @like.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_back fallback_location: posts_path }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("like_buttons_#{@post.id}", partial: "likes/like_buttons", locals: { post: @post, like: @like }) }
        format.html { redirect_back fallback_location: posts_path, alert: "いいねに失敗しました: #{@like.errors.full_messages.to_sentence}" }
      end
    end
  end

  def destroy
    @like = current_user.likes.find_by(id: params[:id])
    if @like&.destroy
      @post = @like.post
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_back fallback_location: posts_path }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("like_buttons_#{@like.post.id}", partial: "likes/like_buttons", locals: { post: @like.post, like: @like }) }
        format.html { redirect_back fallback_location: posts_path, alert: "いいねの解除に失敗しました" }
      end
    end
  end
end
