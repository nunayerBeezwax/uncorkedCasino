require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Users" do
	post '/api/users.json' do
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
end


resource "Games" do
  get "/api/games" do
    example "Listing games" do
	    user = FactoryGirl.create(:user)
		  token = FactoryGirl.create(:api_key)
		  token.update(user_id: user.id)
		  g = FactoryGirl.create(:game)
	    do_request(api_key: user.api_key.access_token)
	    response_body.should == [g].to_json
    end
    example "access denied" do
	    do_request(api_key: "non verified string")
	    response_status.should == 401
    end
  end
end

