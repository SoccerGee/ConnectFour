module ApplicationHelper
  # nav bar abstraction to help with variable authentication states
  def nav_bar
    render partial: "/partials/nav/nav_bar"
  end

  def nav_bar_menus
    partial = user_signed_in? ? "logged_in" : "logged_out"
    render partial: "/partials/nav/#{partial}"
  end

  def display_game_moves
    render template: "/moves/new" if @game.winner.blank?
  end
end
