class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
    else
      session["devise.google_data"] = request.env["omniauth.auth"].except(:extra)
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end

  def failure
    redirect_to root_path, alert: "認証に失敗しました。"
  end
end

# You should also create an action method in this controller like this:
# def twitter
# end

# More info at:
# https://github.com/heartcombo/devise#omniauth

# GET|POST /resource/auth/twitter
# def passthru
#   super
# end

# GET|POST /users/auth/twitter/callback
# def failure
#   super
# end

# protected

# The path used when OmniAuth fails
# def after_omniauth_failure_path_for(scope)
#   super(scope)
# end
# end
