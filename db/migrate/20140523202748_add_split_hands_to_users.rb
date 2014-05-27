class AddSplitHandsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :split_hands, :string
  end
end
