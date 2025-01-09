require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'アソシエーションのテスト' do
    it { is_expected.to have_many(:posts).dependent(:destroy) }
    it { is_expected.to have_many(:tags).dependent(:destroy) }
  end

  describe 'ransackable_attributes のテスト' do
    it 'ransackable_attributes が name を含む' do
      expect(Category.ransackable_attributes).to include('name')
    end
  end
end
