class AddNamesToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :full_name, :string
  	add_column :users, :handle, :string
  end
end
