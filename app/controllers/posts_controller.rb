class PostsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_post, only: [ :show, :edit, :update, :destroy ]
  before_action :set_tags, only: [ :new, :edit, :update ]

  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).includes(:tags, :user, :category).order(created_at: :desc).page(params[:page]).per(6)
    @categories = Category.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      # タグの関連付け
      @post.tag_ids = params[:post][:tag_ids] if params[:post][:tag_ids].present?
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
  end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post), notice: "更新しました"
    else
      flash.now[:danger] = "更新に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy!
    redirect_to posts_path, notice: "削除しました", status: :see_other
  end

  private

  def set_post
    @post = action_name == "show" ? Post.find(params[:id]) : current_user.posts.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to posts_path, alert: "投稿が見つかりませんでした"
  end

  def set_tags
    @standard_tags = Tag.standard
    @category_specific_tags = Category.includes(:tags).where(tag_type: :category_specific)
  end

  def post_params
    params.require(:post).permit(:title, :content, :category_id, :post_image, :ai_corrected_content, :reference_url, tag_ids: [])
  end
end
