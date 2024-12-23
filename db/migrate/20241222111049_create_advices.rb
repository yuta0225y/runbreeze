class CreateAdvices < ActiveRecord::Migration[7.2]
  def change
    create_table :advices do |t|
      t.references :user, null: false, foreign_key: true
      t.text :input
      t.text :response

      t.timestamps
    end
  end
end
