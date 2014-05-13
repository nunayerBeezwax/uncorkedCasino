class AddChipsAndHouseToUsers < ActiveRecord::Migration
  def change
  	
  	add_column :users, :chips, :integer, { default: 500 } 
  end
end
