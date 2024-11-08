class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = Post.includes(:user).all

    if params[:search].present?
      @posts = @posts.where("title ILIKE ?", "%#{params[:search]}%")
    end

    if params[:category].present? && params[:category] != "All"
      @posts = @posts.where(category_id: params[:category])
    end

    @categories = Post.select(:category_id).distinct.pluck(:category_id)
  end

  def new
    @post = Post.new
    @standard_tags = Tag.standard
    @category_specific_tags = Category.includes(:tag).where(tag_type: :category_specific)
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      # タグの関連付け
      if params[:post][:tag_ids].present?
        @post.tag_ids = params[:post][:tag_ids]
      end
      redirect_to posts_path, notice: "投稿しました"
    else
      flash.now[:danger] = "投稿に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :category_id, :image, :ai_corrected_content, :reference_url, tag_ids: [])
  end
end
