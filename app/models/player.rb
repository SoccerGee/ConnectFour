class Player < ApplicationRecord
  has_one :player_type
  has_many :moves
  has_and_belongs_to_many :games

  #This will return the CPU Player Object
  scope :cpu, -> { where(
    type_id: ActiveRecord::Base.connection.exec_query("
      SELECT id FROM player_types WHERE name='cpu' ").first["id"])
  }

  #getting the type name of a Player record.
  def type
    db_query_result = ActiveRecord::Base.connection.exec_query("
      SELECT player_types.name FROM players
      INNER JOIN player_types
      ON players.type_id = player_types.id
      WHERE players.id=#{self.id}").first["name"]
  end
end
