require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションのテスト' do
    subject { build(:user) }

    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_uniqueness_of(:username).case_insensitive }
    it { is_expected.to validate_length_of(:username).is_at_least(3) }
    it { is_expected.to validate_length_of(:username).is_at_most(25) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to allow_value('user@example.com').for(:email) }
    it { is_expected.not_to allow_value('invalid_email').for(:email) }

    it { is_expected.to validate_length_of(:password).is_at_least(4) }
  end

  describe 'アソシエーションのテスト' do
    it { is_expected.to have_many(:posts).dependent(:destroy) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:bookmarks).dependent(:destroy) }
    it { is_expected.to have_many(:bookmark_posts).through(:bookmarks).source(:post) }
    it { is_expected.to have_many(:likes).dependent(:destroy) }
    it { is_expected.to have_many(:like_posts).through(:likes).source(:post) }
    it { is_expected.to have_many(:advices).dependent(:destroy) }
  end

  describe '.from_omniauth メソッドのテスト' do
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

    context '新規ユーザーの場合' do
      it '新しいユーザーを作成する' do
        expect {
          User.from_omniauth(auth)
        }.to change(User, :count).by(1)
      end

      it 'メールアドレスとプロバイダー情報を設定する' do
        user = User.from_omniauth(auth)
        expect(user.email).to eq('test@example.com')
        expect(user.provider).to eq('google_oauth2')
        expect(user.uid).to eq('12345')
      end
    end

    context '既存ユーザーがプロバイダー情報なしの場合' do
      let!(:existing_user) { create(:user, email: 'test@example.com', provider: nil, uid: nil) }

      it 'ユーザー情報を更新する' do
        user = User.from_omniauth(auth)
        expect(user.id).to eq(existing_user.id)
        expect(user.provider).to eq('google_oauth2')
        expect(user.uid).to eq('12345')
      end
    end

    context '既に同じプロバイダーとUIDを持つユーザーが存在する場合' do
      let!(:existing_user) { create(:user, provider: 'google_oauth2', uid: '12345', email: 'test@example.com') }

      it '既存のユーザーを返す' do
        user = User.from_omniauth(auth)
        expect(user.id).to eq(existing_user.id)
      end
    end
  end
end
