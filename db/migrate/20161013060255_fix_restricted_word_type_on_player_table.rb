class FixRestrictedWordTypeOnPlayerTable < ActiveRecord::Migration[5.0]
  def change
    rename_column :players, :type, :type_id
  end
end
