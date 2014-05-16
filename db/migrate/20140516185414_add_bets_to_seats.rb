class AddBetsToSeats < ActiveRecord::Migration
  def change
  	add_column :seats, :placed_bet, :integer, default: 0
  end
end
