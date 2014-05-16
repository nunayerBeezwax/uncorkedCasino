class AddShoesToTables < ActiveRecord::Migration
  def change
  	remove_column :decks, :table_id
  	add_column :cards, :shoe_id, :integer
  	add_column :tables, :shoe_id, :integer
  end
end
