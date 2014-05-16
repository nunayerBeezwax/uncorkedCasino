class RemoveShoeFromTables < ActiveRecord::Migration
  def change
  	remove_column :tables, :shoe_id
  	drop_table :shoes
  end
end
