class MovesController < ApplicationController
  before_action :set_move, only: [:show, :edit, :update, :destroy]
  before_action :set_game, only: :create
  before_action :set_board, only: :create

  # GET /moves
  # GET /moves.json
  def index
    @game = Game.find(game_params[:game_id])
    @moves = @game.moves.group_by { |move| move.user == User.cpu ? :move : :cpu_move  }
  end

  # GET /moves/1
  # GET /moves/1.json
  def show
  end

  # GET /moves/new
  def new
    @move = Move.new
  end

  # get /moves/1/edit
  def edit
  end

  # post /moves
  # post /moves.json
  def create
    @move = Move.new(move_params)
    @game.moves << @move

    respond_to do |format|
      if @move.save

        @cpu_move = cpu_turn
        if @game.is_over?
          format.html { redirect_to @game, notice: "#{@game.winner} won!" }
          format.json { redirect_to @game, notice: "#{@game.winner} won!" }
        else
          format.html { redirect_to @move, notice: 'Move was successfully created.' }
          format.json { render :show, status: :created, location: @move }
        end

      else
        format.html { render :new }
        format.json { render json: @move.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /moves/1
  # PATCH/PUT /moves/1.json
  def update
    respond_to do |format|
      if @move.update(move_params)
        format.html { redirect_to @move, notice: 'Move was successfully updated.' }
        format.json { render :show, status: :ok, location: @move }
      else
        format.html { render :edit }
        format.json { render json: @move.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /moves/1
  # DELETE /moves/1.json
  def destroy
    @move.destroy
    respond_to do |format|
      format.html { redirect_to moves_url, notice: 'Move was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_move
      @move = Move.find(move_params[:id])
    end

    def move_params
      params.require(:move).merge(user_id: current_user.id, game_id: game_params[:game_id]).permit(:x_loc, :y_loc, :user_id, :game_id)
    end

    def game_params
      params.permit(:game_id)
    end

    def cpu_turn
      return nil if @game.is_over?

      cpu_move = Move.new(user_id: User.cpu.id, game_id: @game.id, y_loc: 1)
      cpu_move = @board.best_cpu_move cpu_move
      @game.moves << cpu_move
      cpu_move.save
      cpu_move
    end

    def set_game
      @game = Game.find(game_params[:game_id])
    end

    def set_board
      @board = BoardService.new(game: @game, cpu: User.cpu, player: current_user)
    end
end
