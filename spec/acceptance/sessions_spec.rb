require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Sessions" do
	post '/api/users/sign_in' do
		example "Signing in a New User" do
			user = FactoryGirl.create(:user)
			do_request(:user => {password: user.password , username: user.username})
			response_status.should == 200
			response_body.should include 'access_token'
		end
		example "Refuses sign in on bad credentials" do 
			do_request(user: {username: 'bob', password: 'notarealpassword'})
			response_status.should == 401
		end
	end
end