class ApiKey < ActiveRecord::Base
	belongs_to :user
	before_create :generate_access_token

	def self.sweep
    self.destroy_all(:conditions => ["updated_at < ?", 30.minutes.ago]
	end

	private
	
	def generate_access_token
		begin
			self.access_token = SecureRandom.hex
		end while self.class.exists?(access_token: access_token)
	end

end
