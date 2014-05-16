class Seat < ActiveRecord::Base
	belongs_to :table
	belongs_to :user
	has_many :cards

	def occupied?
		!self.user.nil?
	end

	def place_bet(amount)
		self.update(placed_bet: amount)
	end

	def in_hand?
		self.placed_bet > 0
	end

end

