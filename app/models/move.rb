class Move < ApplicationRecord
  START_VAL = 1
  MAX_X = 7
  MAX_Y = 6

  attr_accessor :win

  belongs_to :user
  belongs_to :game

  before_create :slide_to_bottom

  validates :x_loc, presence: true
  validates_numericality_of :x_loc, less_than_or_equal_to: MAX_X
  validates_numericality_of :x_loc, greater_than_or_equal_to: START_VAL
  validates_numericality_of :y_loc, less_than_or_equal_to: MAX_Y
  validates_numericality_of :y_loc, greater_than_or_equal_to: START_VAL
  validates_uniqueness_of :x_loc, scope: [:y_loc, :game_id]

  def up n=1
    self.y_loc + n
  end

  def down n=1
    self.y_loc - n
  end

  def left n=1
    self.x_loc - n
  end

  def right n=1
    self.x_loc + n
  end

  def is_cpu?
    self.user_id == User.cpu.id
  end

  private

  def assign_user
    self.user = @user
  end

  def slide_to_bottom
    self.y_loc = 1

    until self.valid? do
      self.y_loc += 1
    end
  end

end
