class AddUniqueIndexToPostTags < ActiveRecord::Migration[7.2]
  def change
    # 既存の個別インデックスを削除（存在する場合）
    remove_index :post_tags, :post_id if index_exists?(:post_tags, :post_id)
    remove_index :post_tags, :tag_id if index_exists?(:post_tags, :tag_id)

    # post_id と tag_id の複合ユニークインデックスを追加
    add_index :post_tags, [ :post_id, :tag_id ], unique: true, name: 'index_post_tags_on_post_id_and_tag_id'
  end
end
