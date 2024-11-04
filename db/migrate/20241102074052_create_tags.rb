class CreateTags < ActiveRecord::Migration[7.2]
  def change
    create_table :tags do |t|
      t.references :category, null: false, foreign_key: true
      t.string :name, null: false
      t.timestamps
    end
  end
end
