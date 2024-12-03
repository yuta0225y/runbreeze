class UsersController < ApplicationController
  before_action :authenticate_user!

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

  def edit_password
    @user = current_user
  end

  def update_password
    @user = current_user
    if @user.update_with_password(password_params)
      bypass_sign_in(@user) # パスワード変更後に自動ログイン
      redirect_to mypage_path, notice: "パスワードを更新しました。"
    else
      flash.now[:alert] = "パスワードの更新に失敗しました。"
      render :edit_password, status: :unprocessable_entity
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
