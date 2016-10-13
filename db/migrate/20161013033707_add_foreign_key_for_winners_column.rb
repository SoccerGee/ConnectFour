class AddForeignKeyForWinnersColumn < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key :games, :players, column: :winner_id
  end
end
