class Move < ApplicationRecord

  belongs_to :user
  belongs_to :game

  validates :x_loc, presence: true
  validates :y_loc, presence: true

  def self.cpu_turn user_id, game_id
    Move.where(user_id: user_id).where(game_id: game_id)
  end
end
