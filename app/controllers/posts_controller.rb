class PostsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_post, only: [ :show, :edit, :update, :destroy ]
  before_action :set_tags, only: [ :new, :edit, :update ]

  def index
    @q = Post.published.ransack(params[:q])
    @posts = @q.result(distinct: true).includes(:tags, :user, :category).order(created_at: :desc).page(params[:page]).per(6)
    @categories = Category.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    @post.category_id = nil if params[:draft_save].present? && @post.category_id.blank?
  
    if params[:draft_save].present?
      @post.status = :draft
    else
      @post.status = :published
    end
  
    if @post.save
      redirect_to(params[:draft_save].present? ? drafts_posts_path : posts_path, notice: "保存しました。")
    else
      flash.now[:danger] = "保存に失敗しました。"
      render :new, status: :unprocessable_entity
    end
  end  
  
  def update
    # 既存の投稿を取得
    @post = current_user.posts.find(params[:id])
  
    # 下書き保存と公開の分岐
    if params[:draft_save].present?
      @post.status = :draft # 下書きとして保存
      redirect_path = drafts_posts_path # 下書き一覧ページにリダイレクト
    else
      @post.status = :published # 公開
      redirect_path = post_path(@post) # 投稿詳細ページにリダイレクト
    end
  
    if @post.update(post_params)
      redirect_to redirect_path, notice: params[:draft_save].present? ? "下書きを更新しました。" : "投稿を公開しました。"
    else
      flash.now[:danger] = "更新に失敗しました。"
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @comments = @post.comments.includes(:user).order(:created_at)
  end

  def edit
  end

  def destroy
    @post.destroy!
    redirect_to posts_path, notice: "削除しました", status: :see_other
  end

  def drafts
    @drafts = current_user.posts.draft.order(created_at: :desc).page(params[:page]).per(6)
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
