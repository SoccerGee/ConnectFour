class Player < ApplicationRecord
  has_many :moves

  has_and_belongs_to_many :games

  has_one :player_type, foreign_key: :type
end
