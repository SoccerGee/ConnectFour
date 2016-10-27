class Board

  Space = Struct.new(:x, :y, :user_id, :move_id, :threat_score, :opportunity_score, :is_key_play) do

    def is_open?
      move_id.nil?
    end

    def is_taken?
      move_id.present?
    end

  end

  attr_accessor :spaces

  def initialize
    @spaces = []
  end

  def get_space x, y
    @spaces.select {|s| s.x == x && s.y == y }.first
  end

  def get_column x
    @spaces.select {|s| s.x == x }
  end

  def get_row y
    @spaces.select {|s| s.y == y }
  end

  def next_open_in_column column_number
    open_spaces = get_column(column_number).reject {|space| space.is_taken? } # remove spaces without moves
    open_spaces.min_by {|s| s.y }
  end

  def moves_in_column column_number
    get_column(column_number).reject {|space| space.move_id.nil? } # remove spaces without moves
  end

  def user_moves_in_column column_number, user_id
    # remove spaces without moves that match user_id
    get_column(column_number).reject {|space| space.move_id.nil? || space.user_id != user_id}
  end

  def moves_in_row row_number
    get_row(row_number).reject {|space| space.move_id.nil? } # remove spaces with out moves
  end

  def user_moves_in_row row_number, user_id
    # remove spaces without moves that match user_id
    get_row(row_number).reject {|space| space.move_id.nil? || space.user_id != user_id}
  end

  def moves_in_diagonal x_loc, y_loc
    max_x = Move::MAX_X
    max_y = Move::MAX_Y
    min   = 1

    start_space = get_space x_loc, y_loc
    spaces = [start_space]

    space = start_space
    while space.x < max_x && space.y < max_y do
      space = above_right_space space
      spaces << space if space.present? && space.move_id.present?
    end

    space = start_space
    while space.x > min && space.y < max_y do
      space = above_left_space space
      spaces << space if space.present? && space.move_id.present?
    end

    space = start_space
    while space.x > min && space.y > min do
      space = below_left_space space
      spaces << space if space.present? && space.move_id.present?
    end

    space = start_space
    while space.x < max_x && space.y > min do
      space = below_right_space space
      spaces << space if space.move_id.present?
    end

    spaces
  end

  def user_moves_in_diagonal x_loc, y_loc, user_id
    moves_in_diagonal(x_loc, y_loc).reject{|space| space.user_id != user_id }
  end

  def new_space x, y, user=nil, move=nil, threat_score=0, opportunity_score=0, is_key_play=false
    @spaces << Space.new(x, y, user, move, threat_score, opportunity_score, is_key_play)
  end

  def above_space space
    get_space(space.x, space.y+1)
  end

  def below_space space
    get_space(space.x, space.y-1)
  end

  def left_space space
    get_space(space.x-1, space.y)
  end

  def right_space space
    get_space(space.x+1, space.y)
  end

  def above_left_space space
    get_space(space.x-1, space.y+1)
  end

  def above_right_space space
    get_space(space.x+1, space.y+1)
  end

  def below_left_space space
    get_space(space.x-1, space.y-1)
  end

  def below_right_space space
    get_space(space.x+1, space.y-1)
  end
end
