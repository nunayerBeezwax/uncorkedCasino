require 'spec_helper'

describe Seat do
	it { should belong_to :table }
	it { should belong_to :user }
	it { should have_many :cards}

	before(:each) do
		@house = House.create
		@game = FactoryGirl.create(:game)
		@table = Table.create(game_id: @game.id)
		@user1 = FactoryGirl.create(:user)
		@user2 = FactoryGirl.create(:user)
		@user3 = FactoryGirl.create(:user)
	end

	describe "occupied?" do
		it "returns true if a seat is occupied by a user" do
			@user1.sit(@table)
			@table.seats.sort.first.occupied?.should == true
			@table.seats.last.occupied?.should == false
		end
	end

	describe "in_hand?" do
		it "returns true if a player is currently in the hand" do
			@user1.sit(@table)
			@user2.sit(@table)
			@table.bet(@user1, 5)
			@user1.seat.in_hand?.should eq true
			@user2.seat.in_hand?.should eq false

			### This is the method access non-identity bug
			### the two references equate, but return differing results

			# @user1.seat.should eq @table.seats[0]
			# @table.seats[0].in_hand?.should eq true
		end
	end
end
