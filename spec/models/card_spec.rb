require 'spec_helper'

describe Card do
	it { should belong_to :deck } 
	it { should belong_to :seat }

	describe "played!" do
		it "marks a card as played in database" do
			card = Card.create(rank: 10)
			card.played.should eq false
			card.played!
			card.played.should eq true
		end
	end
end
