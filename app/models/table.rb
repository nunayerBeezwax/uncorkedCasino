class Table < ActiveRecord::Base
	belongs_to :game
	has_many :seats
	has_many :users, through: :seats
	before_create :setup

	attr_reader :house_cards, :limit, :shoe, :action, :action_on

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

	def action(seats_array)
		seats_array.sort.first
	end

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
		action(first_to_act)
	end

	def first_to_act
		fta = []
		self.users.each do |user| 
			if user.seat.in_hand?
				fta << user.seat.number 
			end
		end
		fta
	end

	def hit(user)
		user.seat.cards << self.shoe.shift
		hand = make_hand(user.seat.cards)
		if bust(hand) 
			user.seat.cards = []
			self.game.house.bank += user.seat.placed_bet
			user.seat.place_bet(0)
			stand(user)		
		else
			## Throw it back to the user to decide again
		end
	end

  def stand(user)
  	next_to_act = []
  	self.users.each do |u|
	    if u.seat.in_hand? && u.seat.number > user.seat.number
	    	next_to_act << u.seat.number
	    end
  	end
  	action(next_to_act)
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

	def draw
		hand = make_hand(@house_cards)
		if bust(hand)
			winner
		else
			if hand.inject(:+) <= 16 
				@house_cards << @shoe.shift
				draw
			else
				hand.inject(:+)
			end
		end
	end

### Table state methods

	def winner
		self.users.each do |user|
			user.chips += user.seat.placed_bet * 2
		end
	end

	def showdown
		self.users.each do |user|
			if make_hand(user.seat.cards) < draw
				user.chips += user.seat.placed_bet * 2
				user.seat.update(placed_bet: 0)
				## return win message(?)
			elsif make_hand(user.seat.cards) == draw
				user.chips += user.seat.placed_bet
				user.seat.update(placed_bet: 0)
				## return push message(?)
			else

				self.game.house.bank += user.seat.placed_bet
				user.seat.update(placed_bet: 0)
				## return loss message(?)
			end
		end
	end

	def bust(hand)
		return true if hand.inject(:+) > 21
	end

	def seat_qty
		return 5 if self.game.name == "blackjack" 		
	end

	def player_count
		self.users.count
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
