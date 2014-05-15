class Seat < ActiveRecord::Base
	belongs_to :table
	belongs_to :user
	has_many :cards

	def active?
		binding.pry
		self.user
		##also need to make sure they have
	end
end
