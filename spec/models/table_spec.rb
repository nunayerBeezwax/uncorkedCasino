require 'spec_helper'

describe Table do
  	it { should have_one :shoe }
		it { should have_many :seats }

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
