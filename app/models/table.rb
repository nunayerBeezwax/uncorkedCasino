class Table < ActiveRecord::Base
	belongs_to :game
	has_many :seats
	has_many :users, through: :seats
	before_create :setup



	def seat_qty
		return 5 if self.game.name == "blackjack" 		
	end

	def full_table?
		self.vacancies.length == 0
	end

	def populate_seats
		seat_qty.times { |n| self.seats << Seat.create(number: n+1 ) }

	attr_reader :house_cards, :limit, :shoe, :action

### Table setup 

	def setup
		@house_cards = []
		@limit = [5, 10]
		@shoe = []
		5.times do |i|
			self.seats << Seat.create( number: i + 1  )
		end
		fill_shoe
	end

	def fill_shoe(decks=1)
		decks.times do
			deck = Deck.create
			deck.cards.each do |card|
				self.shoe << card
			end
		end
		self.shoe.shuffle!
	end

### Action methods

  def bet(user, amount)
    if amount.between?(self.limit[0], self.limit[1])
      user.chips -= amount
			user.seat.place_bet(amount)
	    else 
    	## throw a "bet must be between..." error
    end
  end

	def deal
		self.seats.each do |seat|
			if seat.occupied?
				2.times { seat.cards << @shoe.shift }
			end
		end
		2.times { self.house_cards << @shoe.shift }
		## if !dealer_blackjack
		# action
	end

	def action
		self.users.each { |user| return user.seat.number if user.seat.in_hand? }
	end

	def hit(user)
		user.seat.cards << self.shoe.shift
		hand = make_hand(user.seat.cards)
		if bust(hand) 
			user.seat.cards = []
			self.game.house.bank += user.seat.placed_bet
			user.seat.place_bet(0)		
		else
			## Throw it back to the user to decide again
		end
	end

  # def stand(user)
  #   user.seat.standing
  # end

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

	def bust(hand)
		return true if hand.inject(:+) > 21
	end

	def seat_qty
		return 5 if self.game.name == "blackjack" 		
	end

	def player_count
		self.users.count
	end

	def game_name
		self.game.name
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
