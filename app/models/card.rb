class Card < ActiveRecord::Base
	belongs_to :deck
	belongs_to :seat
	belongs_to :shoe

	def played!
		self.played = true
		self
	end
end
