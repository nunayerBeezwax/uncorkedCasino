require 'spec_helper'
require 'rspec_api_documentation/dsl'


resource 'houses' do

before(:each) do
  ApplicationController.any_instance.stub(:restrict_access => true)
  @house = House.create
  @user = User.create
  @user1 = User.create
  @user2 = User.create
  @user3 = User.create
  @user4 = User.create
  @house.games << Game.create(name: "blackjack")
  @house.games.first.tables << Table.create

end

	get '/api/houses' do
		example "Get a list of all the games being played" do
			do_request({:games => 'all'})
			response_status.should == 200
			response_body.should include "blackjack"
		end
	end

	get '/api/houses' do
		example "Get a list of open tables for a specific game" do
			do_request({:games => 'blackjack'})
			response_status.should == 200
			response_body.should include "blackjack"
		end
	end
end