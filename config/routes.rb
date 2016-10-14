Rails.application.routes.draw do
  root 'player#index'

  resources :player, only: [:create, :new]

  get 'sign_in' => 'player#new_session', :as => :new_player_session
  post 'sign_in' => 'player#create_session', :as => :create_player_session
  delete 'sign_out' => 'player#sign_out', :as => :destroy_player_session


end
