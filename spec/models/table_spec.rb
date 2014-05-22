require 'spec_helper'

describe Table do
		it { should have_many :seats }
		it { should have_many :users }

		before(:each) do
			@house = House.create
			@game = FactoryGirl.create(:game)
			@game.update(house_id: @house.id)
			@table = Table.create(game_id: @game.id)
			@user1 = FactoryGirl.create(:user)
			@user2 = FactoryGirl.create(:user)
			@user3 = FactoryGirl.create(:user)
			@user4 = FactoryGirl.create(:user)
			@user5 = FactoryGirl.create(:user)
			@user1.sit(@table)
			@user2.sit(@table)
		end

	describe "#setup" do
		it "prepares a table for blackjack - makes seats and shoe" do
			@table.seats.count.should eq 5
			@table.seats.last.number.should eq 5
			@table.low.should eq 5
			@table.high.should eq 10
			@table.shoe.cards.count.should eq 208
		end
	end

	describe "#bet" do 
		it "allows a player to place a bet, removes their chips, qualifies them to be in hand" do
			@user3.sit(@table)
			@user1.seat.place_bet(7)
			@user2.seat.place_bet(9)
			@user3.seat.place_bet(5)
			@user1.chips.should eq 493
			@user2.chips.should eq 491
			@user3.chips.should eq 495
			@user1.seat.placed_bet.should eq 7
			@user2.seat.placed_bet.should eq 9
			@user3.seat.placed_bet.should eq 5
			@user1.seat.in_hand?.should eq true
			@user2.seat.in_hand?.should eq true
			@user3.seat.in_hand?.should eq true
		end
	end

	describe "#stand" do
		it "allows players to stand, moves action to next player in hand" do
			@user3.sit(@table)
			@user1.seat.place_bet(5)
			@user2.seat.place_bet(5)
			@user3.seat.place_bet(5)
			@table.action.should eq 1
			@table.stand(@user1)
			@table.action.should eq 2
			@table.stand(@user2)
			@table.action.should eq 3
		end
	end

	describe "#hit" do
		it "gives another card when a user requests a hit, then checks for bust" do
			@user1.seat.place_bet(5)
			@user2.seat.place_bet(5)
		  @user1.table.hit(@user1)
			[0,3].should include @user1.seat.cards.count
		end
	end

	describe "#double_down" do
		it "doubles a players bet, deals them one card, and moves action to next player" do
			@user1.seat.place_bet(5)
			@user2.seat.place_bet(5)
			@table.double_down(@user1)
			@table.stand(@user2)
			[10, 0].should include @user1.seat.placed_bet
			[3,0].should include @user1.seat.cards.count
		end
	end

	describe "#deal" do
		it "gives 2 cards to each player who placed a bet" do
			@user1.seat.place_bet(7)
			@user1.seat.placed_bet.should eq 7
			@user2.seat.place_bet(10)
		  @user1.cards.count.should eq 2
		  @user2.seat.cards.count.should eq 2
		 	@table.cards.count.should eq 2
		end
	end

	describe "#draw" do
		it "follows house rules to fill dealer hand, either bust or > 16" do
			@table.cards << Card.new(rank: 4)
			@table.cards << Card.new(rank: 4)
			@table.draw
			if @table.cards.count > 0
				@table.cards.count.should > 2
				@table.handify(@table.cards).inject(:+).should > 16
			end
		end
	end

	describe "#random_card" do
		it "selects an unplayed card from the shoe for dealing, marks as played" do
			@table.cards << @table.random_card
			@table.cards.count.should eq 1
			@table.random_card.played.should eq true
			@table.random_card.class.should eq Card
		end
	end

	describe "#next_hand" do
		it "readies table state for new hand" do
			@user1.seat.place_bet(5)
			@user2.seat.place_bet(5)
			@table.stand(@user1)
			@table.stand(@user2)
			@table.next_hand
			@table.cards.should eq []
			@table.seats.first.cards.should eq []
			@table.action.should eq 1
			@table.shoe.cards.where(played: false).count.should > 30
		end
	end

	describe "#handify" do 
		it "takes in cards and returns a sorted array of integers, 10 maximum" do 
			@user1.seat.cards << Card.new(rank: 10)
			@user1.seat.cards << Card.new(rank: 12)
			@user1.seat.cards << Card.new(rank: 13)
			@user1.seat.cards << Card.new(rank: 2)
			@user1.seat.cards << Card.new(rank: 9)
			@user1.seat.cards << Card.new(rank: 11)
			@table.handify(@user1.seat.cards).should eq [2,9,10,10,10,10]
			@table.handify(@user1.seat.cards).inject(:+).should eq 51
		end
	end

	describe "#blackjack" do
		it "returns boolean result of blackjack if given hand" do
			@user1.seat.cards << Card.new(suit: "h", rank: 1)
			@user1.seat.cards << Card.new(suit: "h", rank: 13)
			@user2.seat.cards << Card.new(suit: "d", rank: 5)
			@user2.seat.cards << Card.new(suit: "c", rank: 9)
			@table.blackjack(@user1.seat.cards).should eq true
			@table.blackjack(@user2.seat.cards).should eq false
		end
	end	

	describe "#bust" do
		it "checks a hand to see if it is over 21" do
			@user1.seat.cards << Card.new(suit: "h", rank: 9)
			@user1.seat.cards << Card.new(suit: "h", rank: 10)
			@user1.seat.cards << Card.new(suit: "h", rank: 13)
			hand = @table.handify(@user1.seat.cards)
			@table.bust(hand).should eq true			
			@user2.seat.cards << Card.new(suit: "h", rank: 9)
			@user2.seat.cards << Card.new(suit: "h", rank: 1)
			@user2.seat.cards << Card.new(suit: "h", rank: 7)
			hand = @table.handify(@user2.seat.cards)
			@table.bust(hand).should eq false
		end
	end

	describe "#dealers_turn?" do
		it "should return true when all the players are bust or standing" do
			@user1.seat.place_bet(7)
			@user2.seat.place_bet(7)
			@table.stand(@user1)
			@table.stand(@user2)
			@table.dealers_turn?.should eq true
		end
		it "should return false when all the players are not done" do
			@user1.seat.place_bet(7)
			@user2.seat.place_bet(7)
			@table.stand(@user1)
			@table.dealers_turn?.should eq false
		end
	end

	describe "#first_to_act" do
		it "starts at the first seat with a placed bet after deal" do
			@user1.seat.place_bet(5)
			@user2.seat.place_bet(5)
			@table.first_to_act.should eq 1
		end
	end

	describe "#action" do
		it "marks which seat's turn it is" do
			@user1.seat.place_bet(5)
			@user2.seat.place_bet(5)
			@table.action.should eq 1
			@table.stand(@user1)
			@user1.table.action.should eq 2
		end
	end

	describe "#seat_qty" do
		it "should determine the number of seats at a table based on the game" do
			@table.game.name.should eq 'blackjack'
			@table.seat_qty.should eq 5
		end
	end

	describe "#vacancies" do
		it "should return the vacant seats at a table" do
			@table.vacancies.count.should eq 3
			@table.vacancies.first.number.should eq 3
			@table.vacancies.length.should eq 3
			@user3.sit(@table)
			@table.vacancies.count.should eq 2
		end
	end

	describe "#first_vacant" do
		it "should return the first vacant seat" do
			@table.first_vacant.number.should eq 3
		end
	end

	describe "#full_table?" do
		it "is true if a table is full" do
			@user3.sit(@table)
			@user4.sit(@table)
			@user5.sit(@table)
			@table.full_table?.should eq true
		end
	end

	describe "#player_count" do
		it "should determine the number of players at a table" do
			@table.player_count.should eq 2
			@user3.sit(@table)
			@user4.sit(@table)
			@table.player_count.should eq 4
		end
	end

	describe "#house_blackjack_payouts" do
		it "immediately ends hand, pushes with other blackjacks else player loses" do
			@user1.seat.update(placed_bet: 5)
			@user2.seat.update(placed_bet: 5)
			@user1.decrement!(:chips, @user1.seat.placed_bet)
			@user2.decrement!(:chips, @user2.seat.placed_bet)
			@user1.chips.should eq 495
			@user1.seat.cards << Card.new(rank: 1)
			@user1.seat.cards << Card.new(rank: 12)
			@user2.seat.cards << Card.new(rank: 3)
			@user2.seat.cards << Card.new(rank: 10)
			@table.cards << Card.new(rank: 1)
			@table.cards << Card.new(rank: 10)
			@table.blackjack(@user1.seat.cards).should eq true
			@table.blackjack(@table.cards).should eq true
			@table.house_blackjack_payouts
			@table.seats.first.user.chips.should eq 500
			@table.seats.first.placed_bet.should eq 0
			@table.seats[1].user.chips.should eq 495
			@table.game.house.bank.should eq 1000000
		end
	end	

	describe "#standard_payouts" do
		it "computes result for each player, updates bank and chips" do
			@user3.sit(@table)
			@user1.seat.update(placed_bet: 5)
			@user2.seat.update(placed_bet: 6)
			@user3.seat.update(placed_bet: 7)
			@user1.decrement!(:chips, @user1.seat.placed_bet)
			@user2.decrement!(:chips, @user2.seat.placed_bet)
			@user3.decrement!(:chips, @user3.seat.placed_bet)
			@user1.seat.cards << Card.new(rank: 8)
			@user1.seat.cards << Card.new(rank: 12)
			@user2.seat.cards << Card.new(rank: 3)
			@user2.seat.cards << Card.new(rank: 10)
			@user3.seat.cards << Card.new(rank: 10)
			@user3.seat.cards << Card.new(rank: 10)
			@table.cards << Card.new(rank: 7)
			@table.cards << Card.new(rank: 10)
			@table.standard_payout(@table.handify(@table.cards).inject(:+))
			@table.users[0].chips.should eq 505
			@table.users.first.seat.placed_bet.should eq 0
			@table.users[1].chips.should eq 494
			@table.users[2].chips.should eq 507
			@table.game.house.bank.should eq 999994
		end
	end
end
