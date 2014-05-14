require 'spec_helper'

describe Seat do
	it { should belong_to :table }
	it { should belong_to :user }
	it { should have_many :cards}
end
