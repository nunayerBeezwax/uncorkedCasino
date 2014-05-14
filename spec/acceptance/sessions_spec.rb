require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Sessions" do
	post '/api/users/sign_in' do
		example "Signing in a New User" do
			user = FactoryGirl.create(:user)
			do_request({:username => user.username, :password => user.password})
			response_status.should == 200
			response_body.should include 'access_token'
		end
	end
end