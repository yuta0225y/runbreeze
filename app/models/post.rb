class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_users, through: :bookmarks, source: :user
  has_many :likes, dependent: :destroy
  has_many :like_users, through: :likes, source: :user

  validates :title, presence: true, length: { maximum: 30 }
  validates :content, presence: true, length: { maximum: 1000 }
  validates :category_id, presence: true
  validate :tag_selection_limit

  mount_uploader :post_image, PostImageUploader

  def self.ransackable_attributes(auth_object = nil)
    %w[title category_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user tags category]
  end

  def tag_selection_limit
    if tags.size > 3
      errors.add(:tags, "は3つまで選択できます")
    end
  end

  # ブックマークしているかどうかを判定
  def bookmarked_by?(user)
    bookmarks.exists?(user_id: user.id)
  end

  # いいねしているかどうかを判定
  def liked_by?(user)
    likes.exists?(user_id: user.id)
  end
end
