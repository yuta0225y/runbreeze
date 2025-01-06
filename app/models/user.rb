class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2]

  # Usernameに関するカスタムバリデーション
  validates :username, presence: true,
                       uniqueness: { case_sensitive: false },
                       length: { minimum: 3, maximum: 25 }

  # その他のカスタムバリデーション
  validates :running_goal, inclusion: { in: ["ダイエット", "記録更新", "健康維持", "ストレス解消", "体力向上", "仲間づくり"] }, allow_blank: true
  validates :running_specs, length: { maximum: 50 }, allow_blank: true
  validates :twitter_url, format: { with: URI::DEFAULT_PARSER.make_regexp }, allow_blank: true
  validates :instagram_url, format: { with: URI::DEFAULT_PARSER.make_regexp }, allow_blank: true
  validates :reference_url1, format: { with: URI::DEFAULT_PARSER.make_regexp }, allow_blank: true
  validates :bio, length: { maximum: 200 }, allow_blank: true

  # プロフィール画像アップロード
  mount_uploader :profile_image, ProfileImageUploader

  # 関連付け
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_posts, through: :bookmarks, source: :post
  has_many :likes, dependent: :destroy
  has_many :like_posts, through: :likes, source: :post
  has_many :advices, dependent: :destroy

  # Ransackで検索可能な属性を指定
  def self.ransackable_attributes(auth_object = nil)
    %w[username]
  end

  # ブックマーク機能
  def bookmark(post)
    bookmark_posts << post
  end

  def unbookmark(post)
    bookmark_posts.destroy(post)
  end

  def bookmark?(post)
    bookmark_posts.include?(post)
  end

  # いいね機能
  def like(post)
    like_posts << post
  end

  def unlike(post)
    like_posts.destroy(post)
  end

  def like?(post)
    like_posts.include?(post)
  end

  # OmniAuthからのユーザー取得または作成
  def self.from_omniauth(auth)
    user = find_by(provider: auth.provider, uid: auth.uid)

    if user
      user
    else
      user = find_by(email: auth.info.email)
      if user
        user.update(provider: auth.provider, uid: auth.uid)
        user
      else
        base_username = auth.info.name.parameterize
        unique_username = base_username
        counter = 1
        while User.exists?(username: unique_username)
          unique_username = "#{base_username}#{counter}"
          counter += 1
        end

        create(
          email: auth.info.email,
          username: unique_username,
          password: Devise.friendly_token[0, 20],
          provider: auth.provider,
          uid: auth.uid,
        )
      end
    end
  end
end
