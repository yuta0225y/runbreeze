class PostsController < ApplicationController
  def index
    @posts = Post.includes(:user).all

    # 検索機能
    if params[:search].present?
      @posts = @posts.where("title ILIKE ?", "%#{params[:search]}%")
    end

    # カテゴリフィルタ
    if params[:category].present? && params[:category] != "All"
      @posts = @posts.where(category_id: params[:category])
    end

    # カテゴリ一覧を取得（ビューで表示するため）
    @categories = Post.select(:category_id).distinct.pluck(:category_id)
  end

  def new
    @post = Post.new
  end


  # def show
  #   @post = Post.find(params[:id])
  # end
end
