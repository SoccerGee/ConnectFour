class CreatePlayer < ActiveRecord::Migration[5.0]
  def change
    create_table :players do |t|
      t.string :email
      t.string :pin
      t.integer :type

      t.timestamps
    end
  end
end
