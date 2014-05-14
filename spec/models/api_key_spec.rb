require 'spec_helper'

describe ApiKey do
 	describe ".sweep" do
 		it "destroys all api tokens older than 1 day" do
 			ApiKey.create(user_id: 1, created_at: (5.days.ago))
	 		ApiKey.create(user_id: 2)
	 		ApiKey.sweep
	 		ApiKey.all.count.should eq 1
 		end
  end

  describe "expired" do
  	it "checks if a token was created more than 1 day ago" do
 			api = ApiKey.create(user_id: 1, created_at: (2.days.ago))
 			api2 = ApiKey.create(user_id: 2)
			api.expired?.should eq true
			api2.expired?.should eq false
		end
 	end

end
