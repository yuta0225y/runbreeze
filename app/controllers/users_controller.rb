# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :authenticate_user!, except: [ :show ]

  def mypage
    @user = current_user
    @posts = @user.posts.published.order(created_at: :desc).page(params[:page]).per(6)
    @liked_posts = @user.like_posts.published.order(created_at: :desc).page(params[:liked_page]).per(6)
    @bookmarked_posts = @user.bookmark_posts.published.order(created_at: :desc).page(params[:bookmarked_page]).per(6)
    @drafts = @user.posts.draft.order(created_at: :desc).page(params[:draft_page]).per(6)
    @show_edit_button = true
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc).page(params[:page]).per(6)
    @show_edit_button = @user == current_user
  rescue ActiveRecord::RecordNotFound
    redirect_to posts_path, alert: "ユーザーが見つかりません"
  end

  def edit_profile
    @user = current_user
  end

  def update_profile
    @user = current_user
    if @user.update(profile_params)
      redirect_to mypage_path, notice: "プロフィールを更新しました。"
    else
      flash.now[:alert] = "プロフィールの更新に失敗しました。"
      @show_edit_button = true
      render :edit_profile, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user).permit(
      :username,
      :email,
      :profile_image,
      :running_goal,
      :running_specs,
      :twitter_url,
      :instagram_url,
      :reference_url1,
      :bio
    )
  end
end
