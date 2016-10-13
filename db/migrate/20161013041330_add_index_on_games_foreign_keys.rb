class AddIndexOnGamesForeignKeys < ActiveRecord::Migration[5.0]
  def change
    add_index :games, :winner_id
  end
end
