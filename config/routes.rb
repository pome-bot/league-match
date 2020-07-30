Rails.application.routes.draw do
  # devise_for :users
  devise_for :users, :controllers => { :registrations => 'users/registrations' }

  root "home#top"
  get "about", to: "home#about"
  get "signout", to: "home#signout"

  resources :users, only: [:index, :show, :edit]
  resources :groups, only: [:index, :new, :edit, :create, :update, :destroy] do
    resources :games, only: :create
    resources :messages, only: :create
    resources :leagues
    namespace :api do
      resources :messages, only: :index, defaults: { format: 'json' }
      resources :games, only: :index, defaults: { format: 'json' }
    end
  end

end
