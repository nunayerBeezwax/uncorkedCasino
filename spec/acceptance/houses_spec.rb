require 'spec_helper'
require 'rspec_api_documentation/dsl'


resource 'houses' do

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
  @table1.populate_seats
  @table2.populate_seats
	@user1.sit(@table1)
	@user2.sit(@table1)
	@user3.sit(@table1)
	@user4.sit(@table2)
end

	get '/api/houses' do
		example "Get a list of all the games being played" do
			@user.sign_in
			do_request({:games => 'all', token: @user.api_key.access_token })
			response_status.should == 200
			response_body.should include "blackjack"
		end
	end

	get '/api/houses' do
		example "Get a list of vacancies for a specific game" do
			@user.sign_in
			do_request({:games => 'blackjack', token: @user.api_key.access_token })
			response_body.should include "{'Table #1':'3/5','Table #2':'1/5'}"
		end
	end
	get '/api/houses' do
		example "Play a game" do
			@user.sign_in
			do_request({:playgame => 'blackjack', token: @user.api_key.access_token})
			# need a current_user helper method
			response_body.should include @table1.to_json
		end
	end
	get '/api/houses' do
		example "leave current table" do
			@user.sign_in
			do_request({leavegame: 'all', token: @user.api_key.access_token})
			@user.seat.should == nil
			response_body.should include @user.to_json
		end
	end
end