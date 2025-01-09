require 'rails_helper'

RSpec.describe Advice, type: :model do
  describe 'アソシエーションのテスト' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'バリデーションのテスト' do
    subject { build(:advice) }  # FactoryBotのファクトリーを使用

    it { is_expected.to validate_presence_of(:input) }

    it 'ユーザーが存在しなければ無効である' do
      subject.user = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:user]).to include('を入力してください')
    end

    it '質問内容が500文字以内の場合は有効である' do
      subject.input = 'a' * 500
      expect(subject).to be_valid
    end

    it '質問内容が500文字を超える場合は無効である' do
      subject.input = 'a' * 501
      expect(subject).not_to be_valid
      expect(subject.errors[:input]).to include('は500文字以内で入力してください')
    end

    context 'responseのバリデーション' do
      it 'responseが800文字以内の場合は有効である' do
        subject.response = 'a' * 800
        expect(subject).to be_valid
      end

      it 'responseが800文字を超える場合は無効である' do
        subject.response = 'a' * 801
        expect(subject).not_to be_valid
        expect(subject.errors[:response]).to include('は800文字以内で入力してください')
      end

      it 'responseがnilの場合でも有効である' do
        subject.response = nil
        expect(subject).to be_valid
      end
    end
  end
end
