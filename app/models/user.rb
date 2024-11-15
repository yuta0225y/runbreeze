class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 3, maximum: 25 }

  # Userが削除されたときに関連するPostも削除される
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  # Ransackで検索可能な属性を指定
  def self.ransackable_attributes(auth_object = nil)
    %w[username]
  end
end
