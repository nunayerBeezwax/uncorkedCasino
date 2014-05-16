require 'spec_helper'

describe User do

it { should have_one :seat }
it { should have_one :table }

	before(:each) do
		@house = House.create
		@game = FactoryGirl.create(:game)
		@table = Table.create(game_id: @game.id)
		@user1 = FactoryGirl.create(:user)
		@user2 = FactoryGirl.create(:user)
		@user3 = FactoryGirl.create(:user)
	end

	describe "set_gravatar_url" do
		it "should set the url of the users gravatar after creation" do
			user = User.create(email: "danieladammiller@gmail.com", username: "dand")
			user.set_gravatar_url
			user.gravatar_url.should == 'http://gravatar.com/avatar/78cd1d73f39ed2dca2395cd6b91ad8a9'
		end
	end

	describe "is_signed_in" do
		it "should return true if the user is signed in" do
			user = User.create(email: "danieladammiller@gmail.com", username: "dand")
			user.sign_in
			user.signed_in?.should == true
		end
	end
	describe "sign_out" do
		it "should destroy the users api_key" do
			user = User.create(email: "danieladammiller@gmail.com", username: "dand")
			user.sign_in
			user.signed_in?.should == true
			user.sign_out
			user.signed_in?.should == false
		end
	end

	# describe "access" do
	# 	it "should be the case that you can check table properties through users" do
	# 		@user1.sit(@table)
	# 		@table.limit.should eq [5, 10]
	# 		@user1.table.limit.should eq [5, 10]
	# 	end
	# end

	describe "sit" do
		it "should allow a user to sit a table" do
			@user1.sit(@table)
			@user1.table.should eq @table
			@user1.seat.table.game.name.should == "blackjack"
		end
		it "should allow a user to specify what seat they want and not allow a user to sit in an occupied seat" do
			@user1.sit(@table)
			@user2.sit(@table, 1).should == false
			@user2.sit(@table, 2).should == true
		end
	end
end









