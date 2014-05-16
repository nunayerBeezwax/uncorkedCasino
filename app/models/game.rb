class Game < ActiveRecord::Base
	has_many :tables
	belongs_to :house

	
end
