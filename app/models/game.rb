class Game < ApplicationRecord
  CONSECUTIVE_FOR_WIN = 4
  CONSECUTIVE_FOR_OPPORTUNITY = CONSECUTIVE_FOR_THREAT = 3

  attr_accessor :winner, :board_service

  has_and_belongs_to_many :users
  has_many :moves, dependent: :nullify, after_add: [:add_to_board, :winning_move?]
  belongs_to :winner, class_name: 'User', foreign_key: "winner_id", optional: true

  def is_over?
    self.winner_id.present?
  end

  def get_user_moves user_id
    self.moves.where(user_id: user_id).sort.to_a
  end

  def evaluate_moves
    #TODO: needs to be the loop and preparation for the moves called at initialization
  end

  private

  def winning_move?(move)
    if @board_service.did_win_with_move? move
      self.winner_id = move.user.id
      self.save
      self.winner = move.user.id == User.cpu.id ? "CPU" : "You"
    end
  end

  def add_to_board move
    @board_service.add_to_board move
  end

end
