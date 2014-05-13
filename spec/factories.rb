require 'spec_helper'

FactoryGirl.define do 
	factory :user do 
		full_name "Bob Wilson"
		handle "DiscordianPope"
		email "bob@bob.com"
		password "password"
		password_confirmation "password"
	end
end
