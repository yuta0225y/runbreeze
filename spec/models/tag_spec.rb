require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'アソシエーションのテスト' do
    it { is_expected.to belong_to(:category).optional }
    it { is_expected.to have_many(:post_tags).dependent(:destroy) }
    it { is_expected.to have_many(:posts).through(:post_tags) }
  end

  describe 'enumのテスト' do
    it 'tag_typeにstandardとcategory_specificが含まれている' do
      expect(Tag.tag_types.keys).to include('standard', 'category_specific')
    end

    it 'tag_typeで正しい値を返す' do
      tag = build(:tag, tag_type: :standard)
      expect(tag.tag_type).to eq('standard')
    end
  end

  describe 'ransackable_attributes のテスト' do
    it 'ransackable_attributes が name を含む' do
      expect(Tag.ransackable_attributes).to include('name')
    end
  end

  describe '保存のテスト' do
    it 'nameが空でも保存できる' do
      tag = build(:tag, name: nil)
      expect(tag).to be_valid
    end
  end
end
