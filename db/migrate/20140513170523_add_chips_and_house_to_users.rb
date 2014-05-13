class AddChipsAndHouseToUsers < ActiveRecord::Migration
  def change
  	remove_column :users, :chips, :integer
  	add_column :users, :chips, :integer, { default: 500 } 
  end
end
