class CreateSeats < ActiveRecord::Migration
  def change
    create_table :seats do |t|
      t.integer :table_id
      t.integer :user_id
      t.integer :number

      t.timestamps
    end
  end
end
