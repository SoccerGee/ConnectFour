module ApplicationHelper
  # nav bar abstraction to help with variable authentication states
  def nav_bar
    render partial: "/partials/nav/nav_bar"
  end

  def nav_bar_menus
    partial = user_signed_in? ? "logged_in" : "logged_out"
    render partial: "/partials/nav/#{partial}"
  end

  def who_won? game
    if game.winner_id == nil
      "In Progress"
    elsif game.winner_id == current_user.id
      "You"
    else
      "CPU"
    end
  end

  def display_game_moves
    if @game.winner_id.blank?
      render template: "/moves/new"
    else
      render template: "/moves/show"
    end
  end
end
