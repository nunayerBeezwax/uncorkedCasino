class Split 

	attr_reader :hands, :user, :split_card

	def initialize(user)
		@user = user
		@split_card = user.seat.cards.last
		@hands = []
		@hand1 = []
		@hand2 = []
		@hands << @hand1
		@hands << @hand2
		@hand1 << user.cards[0]
		@hand2 << user.cards[1]
		@hand1 << user.table.random_card
		@hand2 << user.table.random_card
	end
end