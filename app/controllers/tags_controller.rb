# app/controllers/tags_controller.rb
class TagsController < ApplicationController
  before_action :authenticate_user! # 必要に応じて認証を追加

  def by_category
    category_id = params[:category_id]

    if category_id.blank?
      render json: { error: "カテゴリーIDが指定されていません。" }, status: :bad_request
      return
    end

    category = Category.find_by(id: category_id)

    unless category
      render json: { error: "指定されたカテゴリーが存在しません。" }, status: :not_found
      return
    end

    tags = category.tags.where(tag_type: :category_specific)

    # タグの種類情報も含めて返す
    render json: tags.select(:id, :name, :tag_type)
  end
end
