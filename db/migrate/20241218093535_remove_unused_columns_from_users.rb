class RemoveUnusedColumnsFromUsers < ActiveRecord::Migration[7.2]
  def change
    remove_column :users, :gender, :integer
    remove_column :users, :age, :string
    remove_column :users, :facebook_url, :string
    remove_column :users, :reference_url2, :string
  end
end
