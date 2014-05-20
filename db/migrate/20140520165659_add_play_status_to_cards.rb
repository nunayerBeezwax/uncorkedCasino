class AddPlayStatusToCards < ActiveRecord::Migration
  def change
  	add_column :cards, :played, :boolean, default: false
  end
end
