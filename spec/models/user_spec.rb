require 'spec_helper'

describe User do

	describe "set_gravatar_url" do
		it "should set the url of the users gravatar after creation" do
			user = User.create(email: "danieladammiller@gmail.com", username: "dand")
			user.set_gravatar_url
			user.gravatar_url.should == 'http://gravatar.com/avatar/78cd1d73f39ed2dca2395cd6b91ad8a9'
		end
	end

	describe "is_signed_in" do
		it "should return true if the user is signed in" do
			user = User.create(email: "danieladammiller@gmail.com", username: "dand")
			user.sign_in
			user.signed_in?.should == true
		end
	end
	describe "sign_out" do
		it "should destroy the users api_key" do
			user = User.create(email: "danieladammiller@gmail.com", username: "dand")
			user.sign_in
			user.signed_in?.should == true
			user.sign_out
			user.signed_in?.should == false
		end
	end
end
