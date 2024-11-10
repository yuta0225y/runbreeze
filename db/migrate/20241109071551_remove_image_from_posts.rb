class RemoveImageFromPosts < ActiveRecord::Migration[7.2]
  def change
    remove_column :posts, :image, :string
  end
end
