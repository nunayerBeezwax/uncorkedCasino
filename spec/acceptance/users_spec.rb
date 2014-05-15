require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Users" do

before(:each) do
  ApplicationController.any_instance.stub(:restrict_access => true)
end


	post '/api/users/' do
		example "Signing Up a new user" do
			user = FactoryGirl.build(:user)
			do_request(:user => {email: user.email, password: user.password , username: user.username, password_confirmation: user.password })
			User.all.last.email.should == user.email
			response_body.should == User.all.last.to_json
		end
	end
	get '/api/users/:id' do
		example "Get the state of a user" do
			user = FactoryGirl.create(:user)
			do_request({:id => user.id})
			response_body.should == user.to_json		
		end
	end
	patch '/api/users/:id' do
		example "Edit a users profile" do
			user = FactoryGirl.create(:user)
			do_request({:id => user.id, user: {username: "Dandlezzz"}})
			response_body.should include "Dandlezzz"
		end
	end
	delete '/api/users/:id' do
		example "destroy a user" do
			user = FactoryGirl.create(:user)
			do_request({:id => user.id})
			response_status.should == 204
			User.all.should == []
		end
	end
end
