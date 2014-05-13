require 'spec_helper'
require 'rspec_api_documentation/dsl'

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
  end
end


