class ChangeStatusDefaultOnPosts < ActiveRecord::Migration[7.2]
  def change
    change_column_default :posts, :status, from: nil, to: 0

    # nullを許さないように
    change_column_null :posts, :status, false, 0
  end
end
