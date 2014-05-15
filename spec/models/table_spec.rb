require 'spec_helper'

describe Table do
  	it { should have_many :decks}
		it { should have_many :seats}

	describe "seat_qty" do
		it "should determine the number of seats at a table based on the game" do
			house = House.create
			game = FactoryGirl.create(:game)
			table = FactoryGirl.create(:table)
			table.update(game_id: game.id)
			table.game.name.should == 'blackjack'
			table.seat_qty.should == 5
		end
	end
	describe "player_count" do
			it "should determine the number of players at a table" do
				house = House.create
				game = FactoryGirl.create(:game)
				user1 = FactoryGirl.create(:user)
				table = FactoryGirl.create(:table)
				table.update(game_id: game.id)
				table.seat_qty.times { table.seats << Seat.create }
				user1.sit(table)
				table.player_count.should == 1
			end
		end
end
