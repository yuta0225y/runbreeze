class Advice < ApplicationRecord
  belongs_to :user

  validates :input, presence: true
end
