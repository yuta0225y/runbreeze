class Tag < ApplicationRecord
  belongs_to :category
  has_many :post_tags, dependent: :destroy
  has_many :posts, through: :post_tags
end
