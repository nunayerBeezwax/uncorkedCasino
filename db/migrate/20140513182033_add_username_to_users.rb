class AddUsernameToUsers < ActiveRecord::Migration
  def change
  	remove_column :users, :full_name
  	remove_column :users, :handle
  	add_column :users, :username, :string
  end
end
