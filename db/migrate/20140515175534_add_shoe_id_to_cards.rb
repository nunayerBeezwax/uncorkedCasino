class AddShoeIdToCards < ActiveRecord::Migration
  def change
  	add_column :cards, :shoe_id, :integer
  end
end
