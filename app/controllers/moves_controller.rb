class MovesController < ApplicationController
  before_action :set_move, only: [:show, :edit, :update, :destroy]
  before_action :set_game, only: :create

  # GET /moves
  # GET /moves.json
  def index
    set_game
    @moves = @game.moves.group_by { |move| move.user == User.cpu.first ? :move : :cpu_move  }
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
    @move = new_move
    @move.user = current_user

    respond_to do |format|
      if @move.save
        @cpu_move = cpu_turn
        @cpu_move.save if @game.is_over? == false

        if @game.is_over?
          winner = @game.winner_id == User.cpu.first.id ? "The CPU" : "You"
          format.html { redirect_to @game, notice: "#{winner} won!" }
          format.json { redirect_to @game, notice: "#{winner} won!" }
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

    def new_move
      move = Move.new(move_params)
      move.game = @game
      move
    end

    def set_game
      @game = Game.find(game_params[:game_id])
    end

    def move_params
      params.require(:move).permit(:move,:x_loc,:y_loc,:format)
    end

    def game_params
      params.permit(:game_id)
    end

    def cpu_turn
      a_cpu_move = new_move
      a_cpu_move.user = User.cpu.first
      a_cpu_move.make_cpu_move
      a_cpu_move
    end
end
