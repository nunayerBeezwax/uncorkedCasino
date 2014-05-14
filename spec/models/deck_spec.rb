require 'spec_helper'

describe Deck do
  it { should have_many :cards}
	it { should belong_to :table}
end
