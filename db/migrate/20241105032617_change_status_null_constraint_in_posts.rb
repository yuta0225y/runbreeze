class ChangeStatusNullConstraintInPosts < ActiveRecord::Migration[7.2]
  def change
    change_column_null :posts, :status, true
  end
end
