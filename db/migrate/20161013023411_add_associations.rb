class AddAssociations < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key :games, :players, column: :red_player_id
    add_foreign_key :games, :players, column: :black_player_id
    add_foreign_key :moves, :games
    add_foreign_key :moves, :players
  end
end
