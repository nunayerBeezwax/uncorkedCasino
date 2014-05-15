class Table < ActiveRecord::Base
	belongs_to :game
	has_many :seats
	has_many :decks
	has_many :users, through: :seats

	def seat_qty
		return 5 if self.game.name == "blackjack" 		
	end

	def player_count
		self.users.length
	end
end
