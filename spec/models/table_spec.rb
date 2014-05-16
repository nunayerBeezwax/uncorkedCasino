require 'spec_helper'

## When run individually the tests pass, they fail when run together

describe Table do
		it { should have_many :seats }

		before(:each) do
			@house = House.create
			@game = FactoryGirl.create(:game)
			@table = Table.create(game_id: @game.id)
			@user1 = FactoryGirl.create(:user)
			@user2 = FactoryGirl.create(:user)
			@user3 = FactoryGirl.create(:user)
			@user4 = FactoryGirl.create(:user)
			@user5 = FactoryGirl.create(:user)
		end

	describe "bet" do 
		it "allows a player to place a bet, removes their chips, qualifies them to be in hand" do
			@user1.sit(@table)
			@user2.sit(@table)
			@user3.sit(@table)
			@table.bet(@user1, 5)
			@user1.chips.should == 495
			@user1.seat.placed_bet.should eq 5
		end
	end

	describe "action" do
		it "starts at the first seat with a placed bet after deal" do
			@user1.sit(@table)
			@table.bet(@user1, 5)
			@table.deal
			@table.action.should eq 1
		end
	end

	# describe "stand" do
	# 	it "allows players to stand, moves action to next player in hand" do
	# 		@user1.sit(@table)
	# 		@user2.sit(@table)
	# 		@table.bet(@user1, 5)
	# 		@table.bet(@user2, 5)
	# 		@table.deal
	# 		@table.action.should eq 1
	# 		@table.stand(@user1)
	# 		@table.action.should eq 2
	# 	end
	# end

	describe "hit" do
		it "gives another card when a user requests a hit, then checks for bust" do
			@user1.sit(@table)
			@table.bet(@user1, 5)
		  @user1.seat.cards << Card.new(suit: 'h', rank: 13)
		  @user1.seat.cards << Card.new(suit: 'h', rank: 9)
		  @user1.seat.cards << Card.new(suit: 'h', rank: 8)
			@table.hit(@user1)
			@user1.seat.cards.count.should eq 0
			@table.game.house.bank.should eq 1000005
		end
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
			@table.vacancies.count.should eq 4
			@table.vacancies.first.number.should == 2
			@user2.sit(@table)
			@table.vacancies.count.should eq 3
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
			@user2.sit(@table)
			@user3.sit(@table)
			@table.player_count.should == 3
		end
	end

	describe "#setup" do
		it "prepares a table for blackjack - makes seats and shoe" do
			@table.seats.count.should eq 5
			@table.seats.last.number.should eq 5
		end
	end

	describe "#fill_shoe" do 
		it "takes a number of decks (default 1) and puts the cards in that table's shoe" do
			@table.shoe.count.should eq 52
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
