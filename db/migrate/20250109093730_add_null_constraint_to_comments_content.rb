class AddNullConstraintToCommentsContent < ActiveRecord::Migration[7.2]
  def change
    change_column_null :comments, :content, false
  end
end
