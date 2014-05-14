class AddAssocationsForCardsSeats < ActiveRecord::Migration
  def change
  	add_column :cards, :seat_id, :integer
  	
  end
end
