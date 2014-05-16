class Table < ActiveRecord::Base
	belongs_to :game
	has_many :seats
	has_many :decks
	has_many :users, through: :seats


	def seat_qty
		return 5 if self.game.name == "blackjack" 		
	end


	def populate_seats
		seat_qty.times { |n| self.seats << Seat.create(number: n+1 ) }
	end

	def player_count
		self.users.length
	end

	def vacancies
		vacants = []
		self.seats.each do |seat| 
			if !seat.occupied? 
				vacants << seat
			end
		end
		vacants
	end

	def first_vacant
		self.vacancies.sort.first
	end

end
