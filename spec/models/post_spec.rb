require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'バリデーションのテスト' do
    let(:user) { create(:user) }
    let(:category) { create(:category) }
    let(:post) { build(:post, :published, user: user, category: category) } # :published トレイトを使用

    context '有効な投稿' do
      it '全ての値が正しければ有効である' do
        expect(post).to be_valid
      end
    end

    context 'タイトルのバリデーション' do
      it 'タイトルがない場合は無効である' do
        post.title = nil
        expect(post).not_to be_valid
        expect(post.errors[:title]).to include('を入力してください') # 修正箇所
      end

      it 'タイトルが30文字を超える場合は無効である' do
        post.title = 'a' * 31
        expect(post).not_to be_valid
        expect(post.errors[:title]).to include('は30文字以内で入力してください') # 修正箇所
      end
    end

    context 'コンテンツのバリデーション' do
      it 'コンテンツがない場合は無効である' do
        post.content = nil
        expect(post).not_to be_valid
        expect(post.errors[:content]).to include('を入力してください') # 修正箇所
      end

      it 'コンテンツが1000文字を超える場合は無効である' do
        post.content = 'a' * 1001
        expect(post).not_to be_valid
        expect(post.errors[:content]).to include('は1000文字以内で入力してください') # 修正箇所
      end
    end

    context 'カテゴリーのバリデーション' do
      it 'カテゴリーがない場合は無効である' do
        post.category_id = nil
        expect(post).not_to be_valid
        expect(post.errors[:category_id]).to include('を入力してください') # 修正箇所
      end
    end
  end

  describe 'アソシエーションのテスト' do
    it { should belong_to(:user) }
    it { should belong_to(:category) }
    it { should have_many(:post_tags).dependent(:destroy) }
    it { should have_many(:tags).through(:post_tags) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:bookmarks).dependent(:destroy) }
    it { should have_many(:bookmark_users).through(:bookmarks).source(:user) }
    it { should have_many(:likes).dependent(:destroy) }
    it { should have_many(:like_users).through(:likes).source(:user) }
  end

  describe 'カスタムメソッドのテスト' do
    let(:user) { create(:user) }
    let(:post) { create(:post, :published, user: user) } # :published トレイトを使用

    describe '#bookmarked_by?' do
      it 'ユーザーがブックマークしている場合、trueを返す' do
        post.bookmarks.create(user: user)
        expect(post.bookmarked_by?(user)).to be true
      end

      it 'ユーザーがブックマークしていない場合、falseを返す' do
        expect(post.bookmarked_by?(user)).to be false
      end
    end

    describe '#liked_by?' do
      it 'ユーザーがいいねしている場合、trueを返す' do
        post.likes.create(user: user)
        expect(post.liked_by?(user)).to be true
      end

      it 'ユーザーがいいねしていない場合、falseを返す' do
        expect(post.liked_by?(user)).to be false
      end
    end
  end
end
