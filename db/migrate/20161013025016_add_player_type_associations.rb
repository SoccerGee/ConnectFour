class AddPlayerTypeAssociations < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key :players, :player_types, column: :type
  end
end
