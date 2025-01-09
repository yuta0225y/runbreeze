require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  # Devise を使用するためのヘルパー設定
  include Devise::Test::ControllerHelpers

  describe 'Google OAuth2 callback' do
    let(:auth) do
      OmniAuth::AuthHash.new(
        provider: 'google_oauth2',
        uid: '12345',
        info: {
          email: 'test@example.com',
          name: 'Test User'
        }
      )
    end

    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["omniauth.auth"] = auth
    end

    context 'ユーザーが正常に認証された場合' do
      before do
        # 既存ユーザーを作成し、from_omniauth がそれを返すようにする
        @user = User.create!(
          email: 'test@example.com',
          username: 'test-user',
          password: 'password',
          provider: 'google_oauth2',
          uid: '12345'
        )
      end

      it 'ユーザーをサインインさせリダイレクトする' do
        get :google_oauth2
        expect(response).to redirect_to(root_path)  # リダイレクト先はアプリの設定に依存
        expect(flash[:notice]).to be_present
      end
    end

    context 'ユーザーの保存に失敗した場合' do
        before do
          # エラーを持ったユーザーを返すように設定
          failed_user = User.new
          failed_user.errors.add(:base, "保存エラー")
          allow(User).to receive(:from_omniauth).and_return(failed_user)
        end

        it '新規登録ページにリダイレクトする' do
          get :google_oauth2
          expect(response).to redirect_to(new_user_registration_url)
          expect(flash[:alert]).to be_present
        end
      end
  end
end
