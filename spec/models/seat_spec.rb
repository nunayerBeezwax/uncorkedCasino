require 'spec_helper'

describe Seat do
	it { should belong_to :table }
	it { should belong_to :user }
	it { should have_many :cards}

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


	describe "occupied?" do
		it "returns true if a seat is occupied by a user" do
			@user1.sit(@table)
			@table.seats.sort.first.occupied?.should == true
			@table.seats.last.occupied?.should == false
		end
	end
end
