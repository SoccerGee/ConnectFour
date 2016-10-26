class BoardService
  require 'User'

  attr_accessor :board

  def initialize params
    @player = params[:player]
    @game   = params[:game]
    @cpu    = params[:cpu]
    @moves  = @game.moves
    @board ||= setup_board
  end

  def add_to_board move
    space = @board.get_space move.x_loc, move.y_loc
    space.user_id = move.user_id
    space.move_id = move.id
  end

  def best_cpu_move a_cpu_move
    #if threat = find_threat
    #  a_cpu_move.assign_attributes( threat )
#    elsif opportunity = find_opportunity
#      a_cpu_move = opportunity
    #else
      a_cpu_move = a_cpu_move.go
    #end

    return a_cpu_move
  end

  def did_win_with_move? move
    column   = @board.user_moves_in_column   move.x_loc, move.user_id
    row      = @board.user_moves_in_row      move.y_loc, move.user_id
    diagonal = @board.user_moves_in_diagonal move.x_loc, move.y_loc, move.user_id

    win_in_column?(column) || win_in_row?(row) || win_in_diagonal?(diagonal)
  end

  private
    def win_in_column? column
      return false if column.blank? || column.length < Game::CONSECUTIVE_FOR_WIN
      consecutive=[]
      column.each do |space|
        consecutive << space if consecutive.blank?
        consecutive << space if consecutive[-1].y+1 == space.y
      end
      return consecutive.length >= Game::CONSECUTIVE_FOR_WIN
    end

    def win_in_row? row
      return false if row.blank? || row.length < Game::CONSECUTIVE_FOR_WIN
      consecutive=[]
      row.each do |space|
        consecutive << space if consecutive.blank?
        consecutive << space if consecutive[-1].x+1 == space.x
      end
      return consecutive.length >= Game::CONSECUTIVE_FOR_WIN
    end

    def win_in_diagonal? diagonal
      return false if diagonal.blank? || diagonal.length < Game::CONSECUTIVE_FOR_WIN

    end

    def find_opportunity
      @user_moves = self.moves.where(user_id: User.cpu.id).to_a

      return nil if @user_moves.size < Game::CONSECUTIVE_FOR_OPPORTUNITY

      #------- COLUMN
      # look at columns starting at left and moving right
      # look for 3 moves in a row
      #   place move in that column if move.up is open
      columns_to_search = @user_moves.pluck(:x_loc).sort
      columns_to_search.each do |column_number|
        column_moves = moves_in_column(column_number)
        if get_consecutive_moves_in_column(column_moves).length == Game::CONSECUTIVE_FOR_OPPORTUNITY
          return { x_loc: last_move_column_num } if column_has_threat && is_column_vulnerable(consecutive_column_moves)
        end
      end

      #------- ROW
      rows_to_search = @user_moves.pluck(:y_loc).sort
      # look at rows starting at first and moving up
      rows_to_search.each do |row_number|
        row_moves = moves_in_row(row_number)
        consecutive_row_moves = get_consecutive_moves_in_row(row_moves)

        # look for 3 moves in a row
        if consecutive_row_moves.length == Game::CONSECUTIVE_FOR_OPPORTUNITY
          # place move in front if open
          return {x_loc: moves.last.x_loc}
          # or place move in back if open
          return {x_loc: moves.last.x_loc}
        end

        # look for two moves in a row, a gap, and a move
        if consecutive_row_moves.length == Game::CONSECUTIVE_FOR_OPPORTUNITY - 1
          if row_moves.where(x_loc: consecutive_row_moves.first.left(2)).user_id == User.cpu.id
            gap = {x_loc: consecutive_row_moves.first.left}
          elsif row_moves.find(x_loc: consecutive_row_moves.first.right(2)).user_id == User.cpu.id
            gap = {x_loc: consecutive_row_moves.last.right}
          end
          # place move in gap
          return gap
        end
      end

      #moves = get_consecutive_moves_in_diagonal(@user_moves.last.pluck(:x_loc, :yloc))
      #if moves.length == Game::CONSECUTIVE_FOR_THREAT
      #  return {x_loc: moves.last.x_loc}
      #end
    end

    def find_threat
      column_moves = moves_in_column_for_user last_move_column_num, @cpu
      if column_moves.length >= Game::CONSECUTIVE_FOR_THREAT
        column_hash = get_consecutive_moves_in_column column_moves
        column_has_threat = column_hash.detect{ |k,v| v.length == Game::CONSECUTIVE_FOR_THREAT }
        return { x_loc: last_move_column_num } if column_has_threat && is_column_vulnerable(column_hash)
      end

      row_moves = moves_in_row last_move_row_num
      if row_moves.length >= Game::CONSECUTIVE_FOR_THREAT
        row_hash = get_consecutive_moves_in_row row_moves
        return { x_loc: row_hash[:possible_threats].first }
      end

      #moves = get_consecutive_moves_in_diagonal(@user_moves.last.pluck(:x_loc, :yloc))
      #if moves.length == Game::CONSECUTIVE_FOR_THREAT
      #  return {x_loc: moves.last.x_loc}
      #end
    end

    def get_consecutive_moves_in_column moves

      sorted_moves = moves.sort { |x,y| x.y_loc <=> y.y_loc }
      consecutive_moves = {}
      index=1

      (1..Move::MAX_Y).each do |i|
        move = sorted_moves.select { |m| m.y_loc == i }.to_a.first

        if move.nil?
          index+=1
        else
          consecutive_moves[index] ||= []
          consecutive_moves[index] << move
        end

      end

      return consecutive_moves
    end

    def map_moves_in_row moves
      consecutive_moves = {
        possible_threats: [],
            real_threats: [],
                   moves: {}
      }
      start_key=1
      possible_threat = 2

      (1..Move::MAX_X).each do |i|
        move = moves.sort { |x,y| x.x_loc <=> y.x_loc }.select { |m| m.x_loc == i }.to_a.first

        if move.nil?
          start_key=i+1
          next
        else
          consecutive_moves[:moves][start_key] ||= []
          consecutive_moves[:moves][start_key] << move
          consecutive_moves[:possible_threats].delete i
        end

        if consecutive_moves[:moves][start_key].length > possible_threat
          # find the gap prior to the start of the consecutive
          loc_of_before_threat = start_key - 1
          loc_of_after_threat  = loc_of_before_threat + consecutive_moves[:moves][start_key].length

          # assign the threat to the hash
          consecutive_moves[:possible_threats] ||= []
          consecutive_moves[:possible_threats] << loc_of_before_threat if loc_of_before_threat > 0
          consecutive_moves[:possible_threats] << loc_of_after_threat  if loc_of_after_threat  < Move::MAX_X
        end
      end

      return consecutive_moves
    end

    def get_consecutive_moves_in_diagonal move
      []
    end

    def is_column_vulnerable moves
      # eliminate moves in column that can't possibly create 4 in a row
      # by only operating on the consecutive values that began below 3rd row from bottom
      the_moves = moves.select do |k,v|
        k <= Move::MAX_Y - Game::CONSECUTIVE_FOR_THREAT && v.length == Game::CONSECUTIVE_FOR_THREAT
      end

      #return false if there are not 3 moves in a row
      return false if the_moves.blank?

      # get the top most consecutive move in order to
      # determin if the consecutive moves is still a threat
      top_move = the_moves.values.last.max_by(&:y_loc)
      next_consecutive_opponent_move = self.moves.detect do |move|
        move.x_loc == top_move.x_loc &&
        move.y_loc == top_move.up    &&
           user.id != User.cpu.id       # check if it has previously been blocked
      end

      # if there is not a cpu move ontop of the threatening column
      # then move then the column is a threat
      return next_consecutive_opponent_move.nil?
    end

    def setup_board
      # setup the structs
      board = Board.new # possible_threats, real_threats, spaces

      # scan across the x axis
      (1..Move::MAX_X).each do |x_loc_index|
        # scan across the y axis
        (1..Move::MAX_Y).each do |y_loc_index|

          if move = @moves.select {|m| m.x_loc == x_loc_index && m.y_loc == y_loc_index }.first
            board.new_space(move.x_loc, move.y_loc, move.user_id, move.id)
          else
            board.new_space(x_loc_index, y_loc_index)
          end

        end
      end

      board
    end

end

