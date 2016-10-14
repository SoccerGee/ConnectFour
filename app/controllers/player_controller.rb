#TODO: Port these over to reflect PLAYER to USER::DEVISE refactor
class PlayerController < ApplicationController

  # main entry point of the site
  def index
  end

  # serve login form
  def new_session
  end

  # if email and pin match, then set @current_user and session value
  def create_session
  end

  # destroy session values
  def destroy_session
  end

  # recieve post ajax call and then create player db record from post params
  def create
  end

  # serve player creation form
  def new
  end

  private
  def player_params
  end
end
