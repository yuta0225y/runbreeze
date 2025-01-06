FactoryBot.define do
    factory :post do
      title { "テストタイトル" }
      content { "テストコンテンツ" }
      status { :draft }

      association :user
      association :category

      trait :published do
        status { :published }
      end
    end
  end
