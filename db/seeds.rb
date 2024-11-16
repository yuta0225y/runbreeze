# カテゴリーとカテゴリー専用タグの作成
categories = {
  "トレーニング" => [ "ジョギング", "筋トレ", "ストレッチ", "インターバル", "ビルドアップ", "スピードトレーニング" ],
  "栄養・食事" => [ "食事", "栄養", "サプリメント", "レシピ", "ダイエット", "水分補給", "カロリー" ],
  "ランニングギア" => [ "シューズ", "ウェア", "時計", "キャップ", "小物", "バッグ" ],
  "大会準備" => [ "大会", "エントリー", "コース", "練習", "疲労回復", "ペース配分", "装備チェック" ],
  "健康・怪我予防" => [ "健康", "怪我予防", "ストレッチ", "メンタルケア", "リカバリー", "マッサージ", "疲労" ],
  "大会レポート" => [ "大会結果", "ハイライト", "自己評価", "記録", "感想", "反省", "次回への課題" ]
}

categories.each do |category_name, tags_names|
  category = Category.find_or_create_by(name: category_name)
  tags_names.each do |tag_name|
    Tag.find_or_create_by(name: tag_name, category: category, tag_type: :category_specific)
  end
end

# 標準タグの作成
standard_tags = [ "初心者", "おすすめ", "ヒント", "失敗談", "ベストプラクティス" ]

standard_tags.each do |name|
  Tag.find_or_create_by(name: name, tag_type: :standard)
end

# ダミーユーザーと投稿の作成
if Rails.env.development? || Rails.env.test?
  require 'faker'

  Faker::Config.locale = 'ja'

  5.times do
    user = User.create!(
      username: Faker::Name.name,  # 日本語の名前を生成
      email: Faker::Internet.email,
      password: "password",
      password_confirmation: "password"
    )

    # 各ユーザーに投稿を生成
    custom_words = [ "ランニング", "トレーニング", "栄養", "ストレッチ", "健康" ]

    10.times do
      post = user.posts.create!(
        title: custom_words.sample,  # カスタム単語からランダムにタイトルを選択
        content: "#{Faker::Lorem.paragraph} 〜 #{custom_words.sample}に関する投稿",
        category: Category.order("RANDOM()").first,
        post_image: Faker::LoremFlickr.image(size: "300x300", search_terms: [ 'fitness', 'jogging' ])
      )

      # 投稿にランダムなタグを追加
      post.tag_ids = Tag.pluck(:id).sample(3)
    end
  end
end

