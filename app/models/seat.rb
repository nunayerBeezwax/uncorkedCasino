class Seat < ActiveRecord::Base
	belongs_to :table
	belongs_to :user
	has_many :cards
end
