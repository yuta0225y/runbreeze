# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# カテゴリーとカテゴリー専用タグ
categories = {
  "トレーニング" => ["ジョギング","筋トレ","ストレッチ","インターバル","ビルドアップ", "スピードトレーニング"],
  "栄養・食事" => ["食事","栄養","サプリメント","レシピ","ダイエット","水分補給", "カロリー"],
  "ランニングギア" => ["シューズ","ウェア","時計","キャップ","小物", "バッグ"],
  "大会準備" => ["大会","エントリー","コース","練習","疲労回復", "ペース配分","装備チェック"],
  "健康・怪我予防" => ["健康","怪我予防","ストレッチ","メンタルケア","リカバリー", "マッサージ","疲労"],
  "大会レポート" => ["大会結果","ハイライト","自己評価","記録","感想", "反省","次回への課題"]
}
 
categories.each do |category_name, tags_names|
  category = Category.find_or_create_by(name: category_name)
  tags_names.each do |tag_name|
    Tag.find_or_create_by(name: tag_name, category: category, tag_type: :category_specific)
  end
end

# 標準タグを作成（すべてのカテゴリーで共通）
standard_tags = ["初心者","おすすめ","ヒント", "失敗談","ベストプラクティス"]

standard_tags.each do |name|
  Tag.find_or_create_by(name: name, tag_type: :standard)
end