require 'spec_helper'

describe Table do
  	it { should have_one :shoe }
		it { should have_many :seats }

		before(:each) do
			@house = House.create
			@game = FactoryGirl.create(:game)
			@table = FactoryGirl.create(:table)
			@table.update(game_id: @game.id)
			@table.populate_seats
			@user1 = FactoryGirl.create(:user)
			@user2 = FactoryGirl.create(:user)
			@user3 = FactoryGirl.create(:user)
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
		end
	end

	describe "first_vacant" do
		it "should return the first vacant seat" do
			@user1.sit(@table)
			@table.first_vacant.number.should == 2
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

	describe "#setup" do
		it "prepares a table for blackjack - makes seats and shoe" do
			test_table = Table.create
			test_table.seats.count.should eq 5
		end
	end

	describe "#fill_shoe" do 
		it "takes a number of decks (default 1) and puts the cards in that table's shoe" do
			test_table = Table.create
			test_table.setup
			test_table.fill_shoe(2)
			test_table.shoe.cards.count.should eq 104
			test_table.rack.count.should eq 104
		end
	end

	describe "#deal" do
		it "gives 2 cards to each player who placed a bet" do
			test_table = Table.create
			test_user = User.create
			test_user.update(id: 1)
			test_table.seats.first.update(user_id: test_user.id)
			test_table.deal
			test_table.seats.first.cards.count.should eq 2
		end
	end
end
