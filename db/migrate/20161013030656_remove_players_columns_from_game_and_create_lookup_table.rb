class RemovePlayersColumnsFromGameAndCreateLookupTable < ActiveRecord::Migration[5.0]
  def change
    remove_column :games, :red_player_id, :integer
    remove_column :games, :black_player_id, :integer

    create_join_table :games, :players do |t|
      t.index :game_id
      t.index :player_id
    end
  end
end
