Rails.application.routes.draw do
  resources :games

  devise_for :users

  root "home#index"
end
