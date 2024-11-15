class Category < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :tags, dependent: :destroy

  # Ransackで検索可能なカラム
  def self.ransackable_attributes(auth_object = nil)
    %w[name]
  end
end
