class PlayerController < ApplicationController

  # main entry point of the site
  def index
  end

  # serve login form
  def new_session
    @player = Player.new
  end

  # if email and pin match, then set @current_user and session value
  def create_session
  end

  # destroy session values
  def destroy_session
  end

  # recieve post ajax call and then create player db record from post params
  def create
    if @player.update player_params
      redirect_to
    else

    end
  end

  # serve player creation form
  def new
    @player = Player.new
  end

  private
  def player_params
    params.require(:player).permit(:email,:pin)
  end
end
