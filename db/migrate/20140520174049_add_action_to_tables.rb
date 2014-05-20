class AddActionToTables < ActiveRecord::Migration
  def change
  	add_column :tables, :action, :integer, default: 1
  end
end
