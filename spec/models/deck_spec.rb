require 'spec_helper'

describe Deck do
  it { should have_many :cards }

	describe "make_cards" do 
		it 'makes a standard deck of 52 cards on Deck.create' do
			@test_deck = Deck.create
			@test_deck.cards.count.should eq 52
		end
	end

end
