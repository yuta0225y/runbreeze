class Tag < ApplicationRecord
  belongs_to :category, optional: true  # 標準タグはカテゴリーに属さないため optional: true
  has_many :post_tags, dependent: :destroy
  has_many :posts, through: :post_tags

  enum tag_type: { standard: 0, category_specific: 1 }
  
  # Ransackで検索可能なカラム
  def self.ransackable_attributes(auth_object = nil)
    %w[name]
  end
end
