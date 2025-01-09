FactoryBot.define do
    factory :tag do
      name { "テストタグ" }       # デフォルトのname
      tag_type { :standard }      # デフォルトのtag_type
      association :category       # 関連するカテゴリを生成
    end
  end
