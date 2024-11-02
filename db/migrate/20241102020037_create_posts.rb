class CreatePosts < ActiveRecord::Migration[7.2]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :content, null: false
      t.integer :category_id, null: false
      t.integer :status, null: false
      t.string :image
      t.text :ai_corrected_content
      t.timestamps
    end
  end
end