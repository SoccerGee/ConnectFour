class FixRestrictedWordTypeOnPlayerTypeTable < ActiveRecord::Migration[5.0]
  def change
    rename_column :player_types, :type, :name
  end
end
