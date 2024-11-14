class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :comments, dependent: :destroy

  validates :title, presence: true, length: { maximum: 30 }
  validates :content, presence: true, length: { maximum: 1000 }
  validates :category_id, presence: true
  validate :tag_selection_limit

  mount_uploader :post_image, PostImageUploader

  def tag_selection_limit
    if tags.size > 3
      errors.add(:tags, "は3つまで選択できます")
    end
  end
end
