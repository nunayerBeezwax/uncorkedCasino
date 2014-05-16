require 'spec_helper'

describe Shoe do
	it { should belong_to :table } 
	it { should have_many :cards }
end