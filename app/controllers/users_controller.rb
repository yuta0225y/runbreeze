class UsersController < ApplicationController
  before_action :authenticate_user!, except: [ :show ]

  def mypage
    @user = current_user
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
      render :edit_profile, status: :unprocessable_entity
    end
  end

  # 他のユーザーのプロフィールを表示
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc).page(params[:page]).per(6)
  rescue ActiveRecord::RecordNotFound
    redirect_to posts_path, alert: "ユーザーが見つかりません"
  end

  private

  def profile_params
    params.require(:user).permit(
      :username,
      :email,
      :profile_image,
      :running_goal,
      :running_specs,
      :reference_url1,
      :bio
    )
  end

  def password_params
    params.require(:user).permit(
      :current_password,
      :password,
      :password_confirmation
    )
  end
end
