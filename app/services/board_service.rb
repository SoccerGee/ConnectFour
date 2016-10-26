class BoardService
  def initialize params
    @player = params[:player]
    @game   = params[:game]
    @cpu    = params[:cpu]
  end

  def best_cpu_move a_cpu_move
    if threat = find_threat
      a_cpu_move.assign_attributes( threat )
#    elsif opportunity = find_opportunity
#      a_cpu_move = opportunity
    else
      a_cpu_move = a_cpu_move.go
    end

    return a_cpu_move
  end

  private

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
      @user_moves = @game.moves.where.not(user_id: @cpu.id).to_a

      return nil if @user_moves.size < Game::CONSECUTIVE_FOR_THREAT

      last_move_column_num = @user_moves.first.x_loc
      last_move_row_num = @user_moves.first.y_loc

      column_moves = moves_in_column last_move_column_num
      if column_moves.length >= Game::CONSECUTIVE_FOR_THREAT
        column_hash = get_consecutive_moves_in_column column_moves
        column_has_threat = column_hash.detect{ |k,v| v.length == Game::CONSECUTIVE_FOR_THREAT }
        return { x_loc: last_move_column_num } if column_has_threat && is_column_vulnerable(column_hash)
      end

      row_moves = moves_in_row last_move_row_num
      if row_moves.length >= Game::CONSECUTIVE_FOR_THREAT
        row_hash = get_consecutive_moves_in_row row_moves
        threat = evaluate_row_threats row_hash
        return { x_loc: threat }
      end

      #moves = get_consecutive_moves_in_diagonal(@user_moves.last.pluck(:x_loc, :yloc))
      #if moves.length == Game::CONSECUTIVE_FOR_THREAT
      #  return {x_loc: moves.last.x_loc}
      #end
    end

    def moves_in_column column_number
      @user_moves.select { |move| move.x_loc == column_number }
    end

    def moves_in_row row_number
      @user_moves.select { |move| move.y_loc == row_number }
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

    def get_consecutive_moves_in_row moves
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

    def evaluate_row_threats moves_hash
      binding.pry
      # grab from consecutive moves sets that
      #   have a length of three
      #     beginning before x_loc = 6
      moves_hash

      #   have a length of two or more
      #     separated by one blank
      #       from another consecutive set
      #       with 1 or more
      #if the_moves.blank?
      #end

      #return if the_moves.blank?
    end

end

