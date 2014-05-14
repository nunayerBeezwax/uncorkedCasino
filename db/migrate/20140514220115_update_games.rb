class UpdateGames < ActiveRecord::Migration
  def change
  	remove_column :games, :rules
  	add_column :games, :house_id, :integer
  end
end
