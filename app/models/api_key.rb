class ApiKey < ActiveRecord::Base
	belongs_to :user
	before_create :generate_access_token

	def self.sweep
    self.all.each { |token| token.destroy if token.expired? }
	end

	def expired?
		self.created_at < 1.day.ago 
	end	

private
	
	def generate_access_token
		begin
			self.access_token = SecureRandom.hex
		end while self.class.exists?(access_token: access_token)
	end
end
