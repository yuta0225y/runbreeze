class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [ :show, :edit, :update, :destroy ]

  def index
    @posts = Post.includes(:user).all

    if params[:search].present?
      @posts = @posts.where("title ILIKE ?", "%#{params[:search]}%")
    end

    if params[:category].present? && params[:category] != "All"
      @posts = @posts.where(category_id: params[:category])
    end

    @categories = Category.all.pluck(:id, :name)
  end

  def new
    @post = Post.new
    @standard_tags = Tag.standard
    @category_specific_tags = Category.includes(:tags).where(tag_type: :category_specific)
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

  def show
    @comments = @post.comments.includes(:user).order(:created_at)
  end

  def edit
    @standard_tags = Tag.standard
    @category_specific_tags = Category.includes(:tags).where(tag_type: :category_specific)
  end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post), notice: "更新しました"
    else
      flash.now[:danger] = "更新に失敗しました"
      @standard_tags = Tag.standard
      @category_specific_tags = Category.includes(:tags).where(tag_type: :category_specific)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy!
    redirect_to posts_path, notice: "削除しました", status: :see_other
  end

  private

  def set_post
    @post = current_user.posts.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to posts_path, alert: "投稿が見つかりませんでした。"
  end

  def post_params
    params.require(:post).permit(:title, :content, :category_id, :post_image, :ai_corrected_content, :reference_url, tag_ids: [])
  end
end
