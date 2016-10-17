class Move < ApplicationRecord
  MAX_X = 7
  MAX_Y = 6

  belongs_to :user
  belongs_to :game

  validates :x_loc, presence: true
  validates :y_loc, presence: true

  validates_numericality_of :x_loc, less_than_or_equal_to: MAX_X
  validates_numericality_of :y_loc, less_than_or_equal_to: MAX_Y

  validates_uniqueness_of :x_loc, :scope => [:y_loc, :game_id]

  def self.cpu_turn user_id, game_id
    GameChannel.broadcast_to(user_id, title: 'hello!!!', body: "MISTER PERSON!")
  end
 ##def self.cpu_turn user_id, game_id

 ##  moves = Move.select(:x_loc,:y_loc).where(user_id: user_id).where(game_id: game_id).pluck(:x_loc,:y_loc)

 ##  cpu_x = rand(0..MAX_X)
 ##  cpu_y = rand(0..MAX_Y)
 ##  begin

 ##    move = Move.create(x_loc: cpu_x, y_loc: cpu_y, user_id: user_id, game_id: game_id)
 ##    if move
 ##      return move
 ##    else
 ##      cpu_x = rand(0..MAX_X)
 ##      cpu_y = rand(0..MAX_Y)
 ##    end

 ##  end until moves.include? [cpu_x, cpu_y]

 ##end
end
