Rails.application.routes.draw do
  devise_for :users

  resources :users, except: [:index, :create, :new, :edit, :show, :update, :destroy] do
    resources :games
  end

  root "home#index"
end
