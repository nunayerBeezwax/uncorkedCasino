class ApiKey < ActiveRecord::Base
	belongs_to :user
	before_create :generate_access_token

	def self.sweep
    self.all.each do |token|
    	if token.expired?
    		token.destroy
    	end
    end
	end

	def expired?
		return true if self.created_at < 1.day.ago else false
	end	

	private
	
	def generate_access_token
		begin
			self.access_token = SecureRandom.hex
		end while self.class.exists?(access_token: access_token)
	end

end
