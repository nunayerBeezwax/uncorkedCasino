class AddTablesToCards < ActiveRecord::Migration
  def change
  	add_column :cards, :table_id, :integer
  end
end
