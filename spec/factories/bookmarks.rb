FactoryBot.define do
    factory :bookmark do
      association :user
      association :post
    end
  end
