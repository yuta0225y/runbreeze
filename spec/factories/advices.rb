FactoryBot.define do
    factory :advice do
      input { "サンプルの質問内容" }
      response { "サンプルの回答" }
      association :user
    end
  end
