require 'spec_helper'

describe Card do
	it { should belong_to :deck } 
	it { should belong_to :shoe } 
	it { should belong_to :seat }
end
