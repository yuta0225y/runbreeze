class ChangeCategoryIdNullOnPosts < ActiveRecord::Migration[7.2]
  def change
    change_column_null :posts, :category_id, true
  end
end
