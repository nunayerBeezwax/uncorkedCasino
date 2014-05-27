class AddEndOfHandToTables < ActiveRecord::Migration
  def change
  	add_column :tables, :end_of_hand, :boolean, default: false
  end
end
