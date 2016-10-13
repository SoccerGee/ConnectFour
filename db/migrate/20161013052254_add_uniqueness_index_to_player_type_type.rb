class AddUniquenessIndexToPlayerTypeType < ActiveRecord::Migration[5.0]
  def change
    add_index :player_types, :type, unique: true
  end
end
