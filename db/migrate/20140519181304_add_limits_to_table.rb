class AddLimitsToTable < ActiveRecord::Migration
  def change
    add_column :tables, :low, :integer
    add_column :tables, :high, :integer
  end
end
