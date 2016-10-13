class AddIndexOnMovesForeignKeys < ActiveRecord::Migration[5.0]
  def change
    add_index :moves, :player_id
    add_index :moves, :game_id
  end
end
