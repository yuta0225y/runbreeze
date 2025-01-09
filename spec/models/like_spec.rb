require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'アソシエーションのテスト' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:post) }
  end

  describe '一意性のバリデーションのテスト' do
    let(:user) { create(:user) }
    let(:post) { create(:post) }

    it '同じユーザーが同じ投稿に複数回いいねできない' do
      # 1つ目のLikeを作成
      create(:like, user: user, post: post)

      # 同じユーザーと投稿の組み合わせで2つ目を作成
      duplicate_like = build(:like, user: user, post: post)

      # 無効であることを確認
      expect(duplicate_like).not_to be_valid
      expect(duplicate_like.errors[:user_id]).to include('すでにいいねしています')
    end

    it '異なるユーザーや投稿の組み合わせは有効' do
      # 異なる組み合わせでLikeを作成
      create(:like, user: user, post: post)

      other_user = create(:user)
      other_post = create(:post)

      valid_like = build(:like, user: other_user, post: other_post)

      # 有効であることを確認
      expect(valid_like).to be_valid
    end
  end

  describe '関連するレコードの削除' do
    it 'ユーザーが削除されると、関連するLikeも削除される' do
      user = create(:user)
      post = create(:post)
      create(:like, user: user, post: post)

      expect { user.destroy }.to change(Like, :count).by(-1)
    end

    it '投稿が削除されると、関連するLikeも削除される' do
      user = create(:user)
      post = create(:post)
      create(:like, user: user, post: post)

      expect { post.destroy }.to change(Like, :count).by(-1)
    end
  end
end
