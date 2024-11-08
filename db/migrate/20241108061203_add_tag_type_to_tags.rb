class AddTagTypeToTags < ActiveRecord::Migration[7.2]
  def change
    add_column :tags, :tag_type, :integer, default: 0, null: false
    change_column_null :tags, :category_id, true
  end
end
