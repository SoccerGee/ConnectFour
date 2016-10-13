class CreateGame < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.integer :red_player_id
      t.integer :black_player_id
      t.integer :winner_id

      t.timestamps
    end
  end
end
