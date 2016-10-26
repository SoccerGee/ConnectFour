class Board
  Space = Struct.new(:x, :y, :user_id, :move_id, :threat_score)

  attr_accessor :possible_threats, :real_threats, :spaces

  def initialize possible_threats=[], real_threats=[], spaces=[]
    @spaces           = spaces
    @possible_threats = possible_threats
    @real_threats     = real_threats
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
    []
  end

  def user_moves_in_diagonal x_loc, y_loc, user_id
    []
  end

  def new_space x, y, user=nil, move=nil, score=0
    @spaces << Space.new(x, y, user, move, score)
  end

end
