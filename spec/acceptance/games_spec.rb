require 'spec_helper'
require 'rspec_api_documentation/dsl'


# testing token auth methods
#curl http://localhost:3000/api/games -H 'Authorization: Token token="#{api.key.access_token}"'
# these work as  of 5/15, can't find a good way to test

resource "Games" do
	before(:each) do
	  ApplicationController.any_instance.stub(:restrict_access => true)
	  @house = House.create
	  @user = FactoryGirl.create(:user)
	  @user1 = FactoryGirl.create(:user)
	  @user2 = FactoryGirl.create(:user)
	  @user3 = FactoryGirl.create(:user)
	  @user4 = FactoryGirl.create(:user)
	  @house.games << Game.create(name: "blackjack")
	  @table1 = Table.create(number: 1)
	  @table2 = Table.create(number: 2)
	  @house.games.first.tables << @table1
	  @house.games.first.tables << @table2
		@user1.sit(@table1)
		@user2.sit(@table1)
		@user3.sit(@table1)
		@user4.sit(@table2)
	end
end


