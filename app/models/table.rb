class Table < ActiveRecord::Base
	belongs_to :game
	has_many :seats
	has_many :users, through: :seats
	has_one :shoe
	after_create :setup

	attr_reader :rack

	def setup
		Shoe.create(table_id: self.id)
		seat_qty.times do |i|
			self.seats << Seat.create(table_id: self.id, number: i )
		end
	end

	def seat_qty
		return 5 if self.game.name == "blackjack" 		
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


	def fill_shoe(decks=1)
		decks.times do
			deck = Deck.create
			deck.cards.each do |card|
				self.shoe.cards << card
			end
		end
		rack_em
	end

	def rack_em
		@rack = []
		self.shoe.cards.each do |card|
			@rack << card
		end
		@rack.shuffle!
	end

	def deal
		self.seats.each do |seat|
			if seat.occupied?
				2.times { seat.cards << @rack.shift }
			end
		end
	end

end
