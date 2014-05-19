class Table < ActiveRecord::Base
	belongs_to :game
	has_many :seats
	has_many :cards
	has_one :shoe
	has_many :users, through: :seats
	before_create :setup

	attr_reader :house_cards, :limit, :action, :action_on

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
		self.shoe = Shoe.create
		self.low = 5
		self.high = 10
		5.times do |i|
			self.seats << Seat.create( number: i + 1  )
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
	end

	def next_hand
		@hole_cards = []
		if @shoe.count < 30
			fill_shoe
		end
	end

  def bet(user, amount)
    if amount.between?(self.low, self.high)
      user.chips -= amount
			user.seat.place_bet(amount)
	    else 
    	## throw a "bet must be between..." error
    end
    if !self.seats.find_by_number(user.seat.number + 1).occupied?
    	self.deal
    else 
    	## let next seat's user make a decision
    end
  end


	def deal
		self.seats.each do |seat|
			if seat.occupied?
				2.times { seat.cards << self.shoe.cards.shift }
			end
		end
		2.times { self.cards << self.shoe.cards.shift }
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
		2.times { self.house_cards << self.shoe.shift }
		if !blackjack(house_cards)
			action(first_to_act)
		else
			house_blackjack_payouts
		end
	
	end

  def bet(user, amount)
    if amount.between?(self.low, self.high)
      user.chips -= amount
			user.seat.place_bet(amount)
	  else 
    	## throw a "bet must be between..." error
    end
  end

	def hit(user)
		user.seat.cards << self.shoe.shift
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

  def split(user)
  	## totally unfinished... problematic
  	if handify(user.seat.cards).uniq.count == 1
  		temp_seat = Seat.new(user_id: user.id, table_id: self.id)
  		temp_seat.cards << user.seat.cards.shift
  		temp_seat.cards << @rack.shift
  		## pass it to user decision
  		user.seat.cards << @rack.shift
  		## pass it to user decision
  	end
  end

	def draw
		hand = handify(self.cards)
		if bust(hand)
			dealer_bust_payout
		else
			if hand.inject(:+) <= 16 
				self.cards << @shoe.shift
				draw
			else
				hand.inject(:+)
			end
		end
		handify(self.cards).inject(:+)
	end

### Table state methods

	def handify(cards)
		cards.map { |card| card.rank.between?(10,13) ? 10 : card.rank }.sort
	end

	def action(seats_array)
		seats_array.sort.first
	end

	def first_to_act
		## can be refactored with a map
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

	def standard_payout
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

	def house_blackjack_payouts
		users.each do |user|
			if blackjack(user.seat.cards)
				user.chips += user.seat.placed_bet
				user.seat.update(placed_bet: 0)
			else
				user.seat.update(placed_bet: 0)
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
