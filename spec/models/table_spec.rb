require 'spec_helper'

## When run individually the tests pass, they fail when run together

describe Table do
  	it { should have_one :shoe }
		it { should have_many :seats }

		before(:each) do
			@house = House.create
			@game = FactoryGirl.create(:game)
			@table = FactoryGirl.create(:table)
			@table.update(game_id: @game.id)
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

	describe "player_count" do
		it "should determine the number of players at a table" do
			@user1.sit(@table)
			@table.player_count.should == 1
		end
	end

	describe "#setup" do
		it "prepares a table for blackjack - makes seats and shoe" do
			@table.seats.count.should eq 5
			@table.seats.last.number.should == 5
		end
	end

	describe "#fill_shoe" do 
		it "takes a number of decks (default 1) and puts the cards in that table's shoe" do
			@table.shoe.cards.count.should eq 52
			@table.rack.count.should eq 52
		end
	end

	describe "#deal" do
		it "gives 2 cards to each player who placed a bet" do
			@user1.sit(@table)
			@user2.sit(@table)
			@table.seats.first.user.should eq @user1
			@table.seats[1].user.should eq @user2
			@table.deal
			@table.seats.first.cards.count.should eq 2
			@table.seats[1].cards.count.should eq 2
			@table.seats[2].cards.count.should eq 0
			@table.house_cards.count.should eq 2
		end
	end

	describe "#bust" do
		it "checks a hand to see if it is over 21" do
			@user1.sit(@table)
			@user1.seat.cards << Card.new(suit: "h", rank: 9)
			@user1.seat.cards << Card.new(suit: "h", rank: 10)
			@user1.seat.cards << Card.new(suit: "h", rank: 13)
			hand = @table.make_hand(@user1.seat.cards)
			@table.bust(hand).should eq true
		end
	end
end
