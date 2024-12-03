class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 3, maximum: 25 }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :running_goal, inclusion: { in: ['ダイエット', 'マラソン完走', '健康維持', 'ストレス解消'], message: "%{value} は無効です" }, allow_blank: true
  validates :running_specs, length: { maximum: 255 }, allow_blank: true
  validates :reference_url1, format: { with: URI::DEFAULT_PARSER.make_regexp, message: "有効なURLを入力してください" }, allow_blank: true
  validates :bio, length: { maximum: 200 }, allow_blank: true
  mount_uploader :profile_image, ProfileImageUploader

  # Userが削除されたときに関連するPostも削除される
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_posts, through: :bookmarks, source: :post
  has_many :likes, dependent: :destroy
  has_many :like_posts, through: :likes, source: :post

  # Ransackで検索可能な属性を指定
  def self.ransackable_attributes(auth_object = nil)
    %w[username]
  end

  def bookmark(post)
    bookmark_posts << post
  end

  def unbookmark(post)
    bookmark_posts.destroy(post)
  end

  def bookmark?(post)
    bookmark_posts.include?(post)
  end

  def like(post)
    like_posts << post
  end

  def unlike(post)
    like_posts.destroy(post)
  end

  def like?(post)
    like_posts.include?(post)
  end
end
