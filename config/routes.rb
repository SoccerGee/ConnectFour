Rails.application.routes.draw do
  devise_for :users

  resources :users, except: [:index, :create, :new, :edit, :show, :update, :destroy] do
    # don't cheat!!  no edit for you!!
    # games will never be created with a form.  They simply begin with users (cpu and user).
    resources :games, shallow: true, except: [:edit, :new] do
      resources :moves, shallow:true
    end
  end

  root "home#index"
end
