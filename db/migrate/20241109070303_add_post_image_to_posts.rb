class AddPostImageToPosts < ActiveRecord::Migration[7.2]
  def change
    add_column :posts, :post_image, :string
  end
end
