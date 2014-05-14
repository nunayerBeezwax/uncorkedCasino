require 'spec_helper'

describe Game do
  it {should have_many :tables}
  it {should belong_to :house}
end
