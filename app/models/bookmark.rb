class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :post

  # 同じ投稿を複数回ブックマークできないようにする
  validates :user_id, uniqueness: { scope: :post_id, message: "すでにブックマークしています" }
end
