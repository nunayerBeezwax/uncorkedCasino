require 'spec_helper'
require 'rspec_api_documentation/dsl'



resource "Games" do
  get "/api/games" do
    example "Listing games" do
	    user = FactoryGirl.create(:user)
		 	# needs to create a token on sign in
		 	
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


