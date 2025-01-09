require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'アソシエーションのテスト' do
    it { is_expected.to belong_to(:post) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'バリデーションのテスト' do
    let(:user) { create(:user) }
    let(:post) { create(:post) }
    let(:comment) { build(:comment, user: user, post: post) }

    context 'コメント内容のバリデーション' do
      it 'コメントが有効である場合' do
        expect(comment).to be_valid
      end

      it 'コメントが空の場合は無効である' do
        comment.content = nil
        expect(comment).not_to be_valid
        expect(comment.errors[:content]).to include('を入力してください')
      end

      it 'コメントが300文字以内の場合は有効である' do
        comment.content = 'a' * 300
        expect(comment).to be_valid
      end

      it 'コメントが300文字を超える場合は無効である' do
        comment.content = 'a' * 301
        expect(comment).not_to be_valid
        expect(comment.errors[:content]).to include('は300文字以内で入力してください')
      end
    end

    describe '関連するレコードの削除' do
      it '投稿が削除されると関連するコメントも削除される' do
        post = create(:post)
        comment = create(:comment, post: post)
        expect { post.destroy }.to change(Comment, :count).by(-1)
      end

      it 'ユーザーが削除されると関連するコメントも削除される' do
        user = create(:user)
        comment = create(:comment, user: user)
        expect { user.destroy }.to change(Comment, :count).by(-1)
      end
    end
  end
end
