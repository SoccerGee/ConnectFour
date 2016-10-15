class DropPlayerTypes < ActiveRecord::Migration[5.0]
  def change
    drop_table :player_types
  end
end
