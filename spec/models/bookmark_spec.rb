require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  describe 'アソシエーションのテスト' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:post) }
  end

  describe '一意性のバリデーションのテスト' do
    let(:user) { create(:user) }
    let(:post) { create(:post) }

    it '同じユーザーが同じ投稿を複数回ブックマークできない' do
      # 1つ目のBookmarkを作成
      create(:bookmark, user: user, post: post)

      # 同じユーザーと投稿の組み合わせで2つ目を作成
      duplicate_bookmark = build(:bookmark, user: user, post: post)

      # 無効であることを確認
      expect(duplicate_bookmark).not_to be_valid
      expect(duplicate_bookmark.errors[:user_id]).to include('すでにブックマークしています')
    end

    it '異なるユーザーや投稿の組み合わせは有効' do
      # 異なる組み合わせでBookmarkを作成
      create(:bookmark, user: user, post: post)

      other_user = create(:user)
      other_post = create(:post)

      valid_bookmark = build(:bookmark, user: other_user, post: other_post)

      # 有効であることを確認
      expect(valid_bookmark).to be_valid
    end
  end

  describe '関連するレコードの削除' do
    it 'ユーザーが削除されると、関連するBookmarkも削除される' do
      user = create(:user)
      post = create(:post)
      create(:bookmark, user: user, post: post)

      expect { user.destroy }.to change(Bookmark, :count).by(-1)
    end

    it '投稿が削除されると、関連するBookmarkも削除される' do
      user = create(:user)
      post = create(:post)
      create(:bookmark, user: user, post: post)

      expect { post.destroy }.to change(Bookmark, :count).by(-1)
    end
  end
end
