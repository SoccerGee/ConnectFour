class RemovePlayerTypeTableAndSetTypeToStringValue < ActiveRecord::Migration[5.0]
  def change
    # At this point there is only the seeded CPU in the db.  This is a rough refactor.
    # I'll need wash my hands after this.
    #
    # The scenario is that the type_id foreign key is causing unnecessary complexity.
    # Time to remove it and go with a boolean datatype on the db column and rename to is_cpu.
    # This is okay, because there is only ever going to be one cpu user.
    # This allows for a default value to be set to false,
    # which will handle all but the cpu user in the db.

    remove_foreign_key :players, column: :type_id

    if defined? Player
      Player.first.update(type_id: nil) # There is only one at this point.
    end

    change_column :players, :type_id, :string
    rename_column :players, :type_id, :is_cpu
    change_column_default :players, :is_cpu, false

    if defined? Player
      Player.first.update is_cpu: true
    end

    #sigh... sloppy but it works now
  end
end
