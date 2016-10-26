class Game < ApplicationRecord
  CONSECUTIVE_FOR_WIN = 4
  CONSECUTIVE_FOR_OPPORTUNITY = CONSECUTIVE_FOR_THREAT = 3

  attr_accessor :winner

  has_and_belongs_to_many :users
  has_many :moves, dependent: :nullify, before_add: :slide_to_the_bottom, after_add: :winning_move?
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
    @user_moves = get_user_moves(move.user.id)

    return false if @user_moves.length < Game::CONSECUTIVE_FOR_WIN

    if did_win_with_move?(move)
      self.winner_id = move.user.id
      self.save
      self.winner = move.user.id == User.cpu.id ? "CPU" : "You"
    end
  end

  def did_win_with_move? last_move
    col_moves = @board.moves_in_column(last_move.x_loc)
    row_moves = @board.moves_in_row(last_move.y_loc)

    @board.get_consecutive_moves_in_column(col_moves).detect{ |k,v| v.length >= Game::CONSECUTIVE_FOR_WIN }.present? ||
    @board.get_consecutive_moves_in_row(row_moves)[:moves].detect{ |k,v| v.length >= Game::CONSECUTIVE_FOR_WIN }.present? ||
    @board.get_consecutive_moves_in_diagonal(last_move).length == Game::CONSECUTIVE_FOR_WIN
  end

  def slide_to_the_bottom move
    moves = self.moves
    max = moves.where(x_loc: move.x_loc).maximum(:y_loc)
    move.y_loc = max.nil? ? 1 : max + 1
  end
end
