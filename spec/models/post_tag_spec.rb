require 'rails_helper'

RSpec.describe PostTag, type: :model do
  describe 'アソシエーションのテスト' do
    it { is_expected.to belong_to(:post) }
    it { is_expected.to belong_to(:tag) }
  end

  describe '一意性のバリデーションのテスト' do
    let(:post) { create(:post) }
    let(:tag) { create(:tag) }

    it '同じpost_idとtag_idの組み合わせは無効である' do
      # 1つ目のPostTagを作成
      create(:post_tag, post: post, tag: tag)

      # 2つ目のPostTagを同じ組み合わせで作成
      duplicate_post_tag = build(:post_tag, post: post, tag: tag)
      duplicate_post_tag.validate # バリデーションを手動でトリガー

      # エラーメッセージを動的に取得
      error_message = I18n.t('errors.messages.taken')
      expect(duplicate_post_tag.errors[:post_id]).to include(error_message)
    end

    it '異なるpost_idやtag_idの組み合わせは有効である' do
      # 異なる組み合わせのPostTagを作成
      create(:post_tag, post: post, tag: tag)

      other_post = create(:post)
      other_tag = create(:tag)

      valid_post_tag = build(:post_tag, post: other_post, tag: other_tag)

      # 有効であることを確認
      expect(valid_post_tag).to be_valid
    end
  end
end
