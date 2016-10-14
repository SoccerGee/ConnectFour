class AddForeignKeyToGamesForUsers < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key :games, :users, column: "winner_id"
  end
end
