class CreateShoes < ActiveRecord::Migration
  def change
    create_table :shoes do |t|
    	t.belongs_to :table
    	
    end
  end
end
