class ChangePlayersToUsersOnMoves < ActiveRecord::Migration[5.0]
  def change
    rename_column :moves, :player_id, :user_id
    add_foreign_key :moves, :users
  end
end
