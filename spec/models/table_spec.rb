require 'spec_helper'

describe Table do
  	it { should have_many :decks}
		it { should have_many :seats}
end
