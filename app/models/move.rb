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

  scope :cpu_moves,  -> { where(user_id: User.cpu.first.id ) }

  def self.cpu_turn
    moves = Move.select(:x_loc,:y_loc)
                  .where(user_id: user_id)
                  .where(game_id: game_id)
                  .pluck(:x_loc,:y_loc)
    make_cpu_move
  end

  private

  def make_cpu_move
    begin
      move = Move.create(x_loc: rand(0..MAX_X), y_loc: rand(0..MAX_Y), user_id: User.cpu.first.id, game_id: 14)
    end until move.errors.blank?
  end
end
