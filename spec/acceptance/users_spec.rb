require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Users" do

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

# auth not required for signup obviously
	post '/api/users/' do
		example "Signing Up a new user" do
			user = FactoryGirl.build(:user)
			do_request(:user => {email: user.email, password: user.password , username: user.username, password_confirmation: user.password })
			User.all.last.email.should == user.email
			response_body.should == User.all.last.to_json
		end
	end

	get '/api/users/:id' do
		example "Get the state of a user when they are in a game" do
			@user1.sign_in
			@table1.deal
			do_request({:id => @user1.id})
			response_body.should include 'blackjack'
			response_body.should include 'Hand'
			response_body.should include 'House cards'
			response_body.should include '1'
		end
	end

	patch '/api/users/:id' do
		example "Edit a users profile" do
			user = FactoryGirl.create(:user)
			do_request({:id => user.id, user: {username: "jenny"}})
			response_body.should include "jenny"
		end
	end

	delete '/api/users/:id' do
		example "destroy a user" do
			user = FactoryGirl.create(:user)
			do_request({:id => user.id})
			response_status.should == 204
			User.all.should_not include user
		end
	end
end
