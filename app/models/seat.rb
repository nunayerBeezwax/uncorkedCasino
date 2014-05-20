class Seat < ActiveRecord::Base
	belongs_to :table
	belongs_to :user
	has_many :cards

	def occupied?
		!self.user.nil?
	end

	def place_bet(amount)
	   if amount.between?(self.table.low, self.table.high)
    	self.user.chips -= amount
			self.update(placed_bet: amount)
		end
	end

	def in_hand?
		self.placed_bet > 0
	end
end

