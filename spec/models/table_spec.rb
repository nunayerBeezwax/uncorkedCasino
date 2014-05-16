require 'spec_helper'

describe Table do
  	it { should have_many :decks}
		it { should have_many :seats}

		before(:each) do
			@house = House.create
			@game = FactoryGirl.create(:game)
			@table = FactoryGirl.create(:table)
			@table.update(game_id: @game.id)
			@table.populate_seats
			@user1 = FactoryGirl.create(:user)
			@user2 = FactoryGirl.create(:user)
			@user3 = FactoryGirl.create(:user)
			@user4 = FactoryGirl.create(:user)
			@user5 = FactoryGirl.create(:user)
		end

	describe "seat_qty" do
		it "should determine the number of seats at a table based on the game" do
			@table.game.name.should == 'blackjack'
			@table.seat_qty.should == 5
		end
	end

	describe "vacancies" do
		it "should return the vacant seats at a table" do
			@user1.sit(@table)
			@table.vacancies.first.number.should == 2
			@table.vacancies.length.should == 4
		end
	end

	describe "first_vacant" do
		it "should return the first vacant seat" do
			@user1.sit(@table)
			@table.first_vacant.number.should == 2
		end
	end

	describe "full_table?" do
		it "is true if a table is full" do
			@user1.sit(@table)
			@user2.sit(@table)
			@user3.sit(@table)
			@user4.sit(@table)
			@user5.sit(@table)
			@table.full_table?.should == true
		end
	end

	describe "populate_seats" do
		it "should add the number of seats to the table based on its game" do
			@table.game.name.should == 'blackjack'
			@table.seats.length.should == 5
			@table.seats.last.number.should == 5
			@table.seats.first.number.should == 1
		end
	end



	describe "player_count" do
		it "should determine the number of players at a table" do
			@user1.sit(@table)
			@table.player_count.should == 1
		end
	end
end
