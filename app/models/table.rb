class Table < ActiveRecord::Base
	belongs_to :game
	has_many :seats
	has_many :users, through: :seats
	has_one :shoe
	after_create :setup

	attr_reader :rack, :house_cards, :limit

### Table setup 

	def setup
		@house_cards = []
		@limit = [5, 10]
		Shoe.create(table_id: self.id)
		seat_qty.times do |i|
			self.seats << Seat.create(table_id: self.id, number: i + 1  )
		end
		fill_shoe
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

### Action methods

	def deal
		self.seats.each do |seat|
			if seat.occupied?
				2.times { seat.cards << @rack.shift }
			end
		end
		2.times { self.house_cards << @rack.shift }
	end

	def deal_card(user)
		self.user.seat.cards << @rack.shift
		hand = make_hand(self.user.seat.cards)
		if bust(hand) 
			user.seat.cards = []
			house.chips += user.seat.bet_placed 
			user.seat.bet_placed(0)		
		else
			## Throw it back to the user to decide again
		end
	end

	def bust(hand)
		return true if hand.inject(:+) > 21
	end

	def make_hand(cards)
		hand = []
		cards.each do |card|
			if card.rank.between?(10, 13)
				hand << 10
			else
				hand << card.rank
			end
		end
		hand
	end

### Table state methods

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

end
