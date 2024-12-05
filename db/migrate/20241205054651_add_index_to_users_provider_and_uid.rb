class AddIndexToUsersProviderAndUid < ActiveRecord::Migration[7.2]
  def change
    add_index :users, [ :provider, :uid ], unique: true
  end
end
