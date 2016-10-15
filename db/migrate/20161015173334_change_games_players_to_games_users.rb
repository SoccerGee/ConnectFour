class ChangeGamesPlayersToGamesUsers < ActiveRecord::Migration[5.0]
  def change
    rename_table :games_players, :games_users
    rename_column :games_users, :player_id, :user_id

    add_foreign_key :games_users, :users
    add_foreign_key :games_users, :games
  end
end
