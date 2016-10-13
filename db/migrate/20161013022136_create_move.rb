class CreateMove < ActiveRecord::Migration[5.0]
  def change
    create_table :moves do |t|
      t.integer :x_loc
      t.integer :y_loc
      t.integer :player_id
      t.integer :game_id

      t.timestamps
    end
  end
end
