require 'spec_helper'
require 'rspec_api_documentation/dsl'




resource "Games" do

before(:each) do
  ApplicationController.any_instance.stub(:restrict_access => true)
end
  get "/api/games" do
    example "Listing games" do
	    user = FactoryGirl.create(:user)
		 	user.sign_in
		  g = FactoryGirl.create(:game)
	    do_request
	    response_body.should == [g].to_json
    end
    # example "access denied" do
	   #  user = FactoryGirl.create(:user)
		 	# user.sign_in
		 	# expired_token = user.api_key.access_token
		 	# user.sign_out
		 	# g = FactoryGirl.create(:game)
	   #  do_request(api_key: expired_token)
	   #  response_status.should == 401
    # end
   #  example "Access denied - timeout" do 
   #  	user = FactoryGirl.create(:user)
		 # 	user.sign_in
		 # 	user.api_key.update(:created_at => (DateTime.now-2))
		 # 	ApiKey.sweep
		 # 	# this is handled by the cronjob and whenever gem, hard to test
		 # 	do_request
		 # 	response_status.should == 401
  	# end
  end
end


