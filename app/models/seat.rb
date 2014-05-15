class Seat < ActiveRecord::Base
	belongs_to :table
	belongs_to :user
	has_many :cards

	attr_reader :bet_placed

	def occupied?
		!self.user.nil?
	end

	def place_bet(amount)
		@bet_placed = amount
	end
end

