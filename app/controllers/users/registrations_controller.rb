class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # サインアップ後にリダイレクトするパスを指定
  def after_sign_up_path_for(resource)
    posts_path
  end

  # アカウント更新後にリダイレクトするパスを指定
  def after_update_path_for(resource)
    mypage_path
  end

  protected

  # サインアップ時に許可するパラメータを追加
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :profile_image, :running_goal, :running_specs, :reference_url1, :bio])
  end

  # アカウント更新時に許可するパラメータを追加
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :profile_image, :running_goal, :running_specs, :reference_url1, :bio, :password, :password_confirmation, :current_password])
  end
end

