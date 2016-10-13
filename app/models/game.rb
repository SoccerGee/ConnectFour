class Game < ApplicationRecord
  has_one :players, foreign_key: :winner_id

  has_and_belongs_to_many :players
end
