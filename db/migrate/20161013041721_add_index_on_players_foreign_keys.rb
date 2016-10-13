class AddIndexOnPlayersForeignKeys < ActiveRecord::Migration[5.0]
  def change
    add_index :players, :type
  end
end
