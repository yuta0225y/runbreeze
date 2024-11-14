class AddProfileFieldsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :profile_image, :string unless column_exists?(:users, :profile_image)
    add_column :users, :gender, :integer unless column_exists?(:users, :gender)
    add_column :users, :age, :string unless column_exists?(:users, :age)
    add_column :users, :running_goal, :string unless column_exists?(:users, :running_goal)
    add_column :users, :running_specs, :string unless column_exists?(:users, :running_specs)
    add_column :users, :instagram_url, :string unless column_exists?(:users, :instagram_url)
    add_column :users, :twitter_url, :string unless column_exists?(:users, :twitter_url)
    add_column :users, :facebook_url, :string unless column_exists?(:users, :facebook_url)
    add_column :users, :reference_url1, :string unless column_exists?(:users, :reference_url1)
    add_column :users, :reference_url2, :string unless column_exists?(:users, :reference_url2)
    add_column :users, :bio, :text unless column_exists?(:users, :bio)
  end
end
