class Advice < ApplicationRecord
  belongs_to :user

  validates :input, presence: true, length: { maximum: 500 }
  validates :response, length: { maximum: 800 }, allow_blank: true
end
