class CreateHouses < ActiveRecord::Migration
  def change
    create_table :houses do |t|
      t.integer :bank, default: 1000000

      t.timestamps
    end
  end
end
