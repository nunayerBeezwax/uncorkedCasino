class CreateTables < ActiveRecord::Migration
  def change
    create_table :tables do |t|
      t.integer :game_id

      t.timestamps
    end
  end
end
