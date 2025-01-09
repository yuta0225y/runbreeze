FactoryBot.define do
    factory :post_tag do
      association :post
      association :tag
    end
  end
