class DeletePlayerTable < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key :moves, :players
    remove_foreign_key :games, :players
    drop_table :players
  end
end
