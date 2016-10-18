class Move < ApplicationRecord
  START_VAL = 1
  MAX_X = 7
  MAX_Y = 6

  attr_accessor :win

  belongs_to :user
  belongs_to :game

  validates :x_loc, presence: true

  validates_numericality_of :x_loc, less_than_or_equal_to: MAX_X
  validates_numericality_of :x_loc, greater_than_or_equal_to: START_VAL

  validates_numericality_of :y_loc, less_than_or_equal_to: MAX_Y
  validates_numericality_of :y_loc, greater_than_or_equal_to: START_VAL

  before_create :slide_to_the_bottom
  after_create :winning_move?

  scope :cpu_moves, -> { where(user_id: User.cpu.first.id ) }


  def make_cpu_move
    begin
      self.x_loc = rand(START_VAL..MAX_X)
      self.y_loc = rand(START_VAL..MAX_Y)
    end until valid_move?
    self
  end

  private

  def winning_move?
    self.game.winning_move? self
  end

  def slide_to_the_bottom
    self.y_loc = 1
    until bottom_most?
      self.y_loc += 1
    end
  end

  def valid_move?
    self.valid? && bottom_most?
  end

  def bottom_most?
    self.game.moves.find_by(x_loc:x_loc, y_loc: self.y_loc).blank?
  end
end
