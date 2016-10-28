class BoardService
  attr_accessor :board

  def initialize params
    @player = params[:player]
    @game   = params[:game]
    @cpu    = params[:cpu]
    @moves  = @game.moves
    setup_board
  end

  def add_to_board move
    space = @board.get_space move.x_loc, move.y_loc
    space.user_id = move.user_id
    space.move_id = move.id
  end

  def best_cpu_move a_cpu_move
    user_move = @moves[-1]

    # map out the best column to place move
    assign_scores

    # find the best average score of opportunity and threat
    possible_moves_hash = @board.spaces.collect do |space|
      #slight advantage to threats
      average_score = space.threat_score + (space.opportunity_score * 0.1)
      { x_loc: space.x, y_loc: space.y, score: average_score, is_key_play: space.is_key_play }
    end

    key_moves = possible_moves_hash.select {|move| move[:is_key_play] }

    if key_moves.present?
      best_move = key_moves.max_by{|move| move[:score] }
    else
      best_move = possible_moves_hash.max_by{|move| move[:score] }
    end

    # decorate the cpu's move
    a_cpu_move.x_loc = best_move[:x_loc]
    a_cpu_move.y_loc = best_move[:y_loc]

    return a_cpu_move
  end

  def did_win_with_move? move
    column   = @board.user_moves_in_column   move.x_loc, move.user_id
    row      = @board.user_moves_in_row      move.y_loc, move.user_id
    diagonal = @board.user_moves_in_diagonal move.x_loc, move.y_loc, move.user_id

    n_consecutive_in_column(column, Game::CONSECUTIVE_FOR_WIN) ||
    n_consecutive_in_row(row, Game::CONSECUTIVE_FOR_WIN) ||
    n_consecutive_in_diagonal(diagonal,Game::CONSECUTIVE_FOR_WIN)
  end

  private

    def n_consecutive_in_column column, n
      return false if column.blank? || column.length < n
      consecutive=[]
      column.each do |space|
        consecutive << space if consecutive.blank?
        consecutive << space if consecutive[-1].y+1 == space.y
      end
      return consecutive.length >= n
    end

    def n_consecutive_in_row row, n
      return false if row.blank? || row.length < n
      consecutive=[]
      row.each do |space|
        consecutive << space if consecutive.blank?
        consecutive << space if consecutive[-1].x+1 == space.x
      end
      return consecutive.length >= n
    end

    def n_consecutive_in_diagonal diagonal, n
      return false if diagonal.blank? || diagonal.length < n

      consecutive=[]

      sorted_diagonal = diagonal.sort {|a,b|a.y<=>b.y} # ascending along y means up!

      sorted_diagonal.each do |space|
        consecutive << space if consecutive.blank?
        consecutive << space if consecutive[-1].x+1 == space.x && consecutive[-1].y+1 == space.y
      end
      return true if consecutive.length >= n

      sorted_diagonal.each do |space|
        consecutive << space if consecutive.blank?
        consecutive << space if consecutive[-1].x-1 == space.x && consecutive[-1].y+1 == space.y
      end
      return consecutive.length >= n
    end

    def setup_board
      # setup the structs
      @board = Board.new # possible_threats, real_threats, spaces

      # scan across the x axis
      (1..Move::MAX_X).each do |x_loc_index|

        # scan across the y axis
        (1..Move::MAX_Y).each do |y_loc_index|
          if move = @moves.select {|m| m.x_loc == x_loc_index && m.y_loc == y_loc_index }.first
            @board.new_space(move.x_loc, move.y_loc, move.user_id, move.id)
            last_user_id = move.user_id
          else
            @board.new_space(x_loc_index, y_loc_index)
          end
        end
      end
    end

    def assign_scores
      # evaluate each column and give
      # score to next available
      (1..Move::MAX_X).each do |i|
        space = @board.next_open_in_column i
        assign_score_for_space space unless space.nil?
      end
    end

    def assign_score_for_space space
      score_space(space,space){|s| @board.below_space(s) }
      score_space(space,space){|s| @board.left_space(s) }
      score_space(space,space){|s| @board.right_space(s) }
      score_space(space,space){|s| @board.above_right_space(s) }
      score_space(space,space){|s| @board.above_left_space(s) }
      score_space(space,space){|s| @board.below_right_space(s) }
      score_space(space,space){|s| @board.below_left_space(s) }
    end

    def score_space space, current, n=1, &block

      neighbor = block.call(current)
      return false if neighbor.nil? || neighbor.is_open?

      if neighbor.user_id == @cpu.id
        space.opportunity_score += 1
      else
        space.threat_score += 1
      end

      space.is_key_play = true if n == 3

      new_neighbor = block.call(neighbor)

      if  new_neighbor.present? &&
          new_neighbor.is_taken? &&
          new_neighbor.user_id == neighbor.user_id

        score_space(space, neighbor, n+1, &block)

      end
    end
end

