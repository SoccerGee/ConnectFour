class UniqueIndexOnPlayerEmail < ActiveRecord::Migration[5.0]
  def change
    add_index :players, :email, unique: true
  end
end
