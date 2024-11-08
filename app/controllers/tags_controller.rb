class TagsController < ApplicationController
  def by_category
    # パラメーターからカテゴリーIDを取得し、それに対応するタグを取得
    category_id = params[:category_id]
    tags = Tag.where(category_id: category_id, tag_type: :category_specific)

    # JSON形式でタグ情報を返す
    render json: tags.select(:id, :name)
  end
end
