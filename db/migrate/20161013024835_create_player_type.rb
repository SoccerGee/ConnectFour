class CreatePlayerType < ActiveRecord::Migration[5.0]
  def change
    create_table :player_types do |t|
      t.string :type
    end
  end
end
