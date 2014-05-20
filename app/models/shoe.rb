class Shoe < ActiveRecord::Base
	belongs_to :table
	has_many :cards
end
