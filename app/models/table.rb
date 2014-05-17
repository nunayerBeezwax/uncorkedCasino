class Table < ActiveRecord::Base
	belongs_to :game
	has_many :seats
	has_many :users, through: :seats
	before_create :setup

	attr_reader :house_cards, :limit, :shoe, :action, :action_on

	def seat_qty
		return 5 if self.game.name == "blackjack" 		
	end

	def full_table?
		self.vacancies.length == 0
	end

	def populate_seats
		seat_qty.times { |n| self.seats << Seat.create(number: n+1 ) }
	end
	

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

	def next_hand
		@hole_cards = []
		if @shoe.count < 30
			fill_shoe
		end
	end

### Action methods

	def deal
		self.seats.each do |seat|
			if seat.occupied?
				2.times { seat.cards << @shoe.shift }
			end
		end
		2.times { self.house_cards << @shoe.shift }
		if !blackjack(house_cards)
			action(first_to_act)
		##  else go to house blackjack payouts
		end
	end

  def bet(user, amount)
    if amount.between?(self.limit[0], self.limit[1])
      user.chips -= amount
			user.seat.place_bet(amount)
	  else 
    	## throw a "bet must be between..." error
    end
  end

	def hit(user)
		user.seat.cards << @shoe.shift
		if bust(handify(user.seat.cards)) 
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

  def double_down(user)
  	user.seat.placed_bet *= 2
  	self.hit(user)
  	self.stand(user)
  end

	def draw
		hand = handify(@house_cards)
		if bust(hand)
			dealer_bust_payout
		else
			if hand.inject(:+) <= 16 
				@house_cards << @shoe.shift
				draw
			else
				hand.inject(:+)
			end
		end
		handify(@house_cards).inject(:+)
	end

### Table state methods

	def handify(cards)
		cards.map { |card| card.rank.between?(10,13) ? 10 : card.rank }.sort
	end

	def action(seats_array)
		seats_array.sort.first
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

	def blackjack(cards)
		jack = handify(cards) & [1,10,11,12,13]
		if jack.count == 2 && jack.include?(1)
			true
		end
	end

	def bust(hand)
		return true if hand.inject(:+) > 21
	end

	def dealer_bust_payout
		self.users.each do |user|
			user.chips += user.seat.placed_bet * 2
		end
	end

	def showdown
		self.users.each do |user|
			if handify(user.seat.cards) < draw
				user.chips += user.seat.placed_bet * 2
				user.seat.update(placed_bet: 0)
				## return win message(?)
			elsif handify(user.seat.cards) == draw
				user.chips += user.seat.placed_bet
				user.seat.update(placed_bet: 0)
				## return push message(?)
			else

				self.game.house.bank += user.seat.placed_bet
				user.seat.update(placed_bet: 0)
				## return loss message(?)
			end
		end
		next_hand
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
