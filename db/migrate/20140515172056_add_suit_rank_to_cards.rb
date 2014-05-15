class AddSuitRankToCards < ActiveRecord::Migration
  def change
  	add_column :cards, :suit, :string
  	add_column :cards, :rank, :integer
  end
end
