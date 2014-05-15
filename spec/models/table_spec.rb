require 'spec_helper'

describe Table do
  	it { should have_many :decks}
		it { should have_many :seats}

		before(:each) do
			@house = House.create
			@game = FactoryGirl.create(:game)
			@table = FactoryGirl.create(:table)
		end

	describe "seat_qty" do
		it "should determine the number of seats at a table based on the game" do
			@table.update(game_id: @game.id)
			@table.game.name.should == 'blackjack'
			@table.seat_qty.should == 5
		end
	end

	describe "populate_seats" do
		it "should add the number of seats to the table based on its game" do
			@table.update(game_id: @game.id)
			@table.game.name.should == 'blackjack'
			@table.populate_seats
			@table.seats.length.should == 5
		end
	end

	describe "player_count" do
		it "should determine the number of players at a table" do
			user1 = FactoryGirl.create(:user)
			@table.update(game_id: @game.id)
			@table.populate_seats
			user1.sit(@table)
			@table.player_count.should == 1
		end
	end
end
