class Table < ActiveRecord::Base
	belongs_to :game
	has_many :seats
	has_many :decks
end
