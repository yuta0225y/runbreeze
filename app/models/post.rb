class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  validates :title, presence: true, length: { maximum: 30 }
  validates :content, presence: true, length: { maximum: 1000 }
  validates :category_id, presence: true

  mount_uploader :post_image, PostImageUploader
end
