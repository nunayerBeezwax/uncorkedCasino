require 'spec_helper'
require 'rspec_api_documentation/dsl'


# testing token auth methods
#curl http://localhost:3000/api/games -H 'Authorization: Token token="#{api.key.access_token}"'
# these work as  of 5/15, can't find a good way to test

resource "Games" do

before(:each) do
  ApplicationController.any_instance.stub(:restrict_access => true)
end


end


