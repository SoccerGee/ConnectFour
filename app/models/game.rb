class Game < ApplicationRecord
  CONSECUTIVE_FOR_WIN = 4

  attr_accessor :for_user

  has_many :moves, dependent: :nullify
  has_and_belongs_to_many :users

  belongs_to :winner, class_name: 'User', foreign_key: "winner_id", optional: true

  # callbacks must be declared after relations or you will get duplicates in the join table...
  # https://github.com/rails/rails/commit/d1afd987464717f8af1ab0e9a78af6f37b9ce425
  after_create :assign_users

  def winning_move? move
    @user_moves = self.moves.where("user_id = ?",move.user.id)

    if vertical_win?(move) || horizontal_win?(move) || diagonal_win?(move)
      self.winner_id = move.user.id
      self.save
    end
  end

  def is_over?
    self.winner_id.present?
  end

  private

  def assign_users
    self.users << [self.for_user, User.cpu]
  end

  def vertical_win? move
    arr = @user_moves.where(x_loc: move.x_loc).pluck(:y_loc).sort
    arr.each_cons(2).all? {|a,b| b == a + 1 } if four_or_more? arr
  end

  def horizontal_win? move
    arr = @user_moves.where(y_loc: move.y_loc).pluck(:x_loc).sort
    arr.each_cons(2).all? {|a,b| b == a + 1 } if four_or_more? arr
  end

  def diagonal_win? move
    binding.pry
    arr = @user_moves.where(y_loc: move.y_loc).pluck(:x_loc).sort
    arr.each_cons(2).all? {|a,b| b == a + 1 } if four_or_more? arr
  end

  def four_or_more? arr
    arr.size >= CONSECUTIVE_FOR_WIN
  end
end
