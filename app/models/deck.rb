class Deck < ActiveRecord::Base
	belongs_to :table
	has_many :cards
	after_create :make_cards

	def make_cards
		rank = %w{ 1 2 3 4 5 6 7 8 9 10 11 12 13 }
		suit = %w{ C S H D }
		suit.each do |suit| 
			rank.each do |rank| 
				self.cards << Card.new({suit: suit, rank: rank, deck_id: self.id})
			end
		end
	end
end
