Rails.application.routes.draw do
  # devise_for :users
  devise_for :users, :controllers => { :registrations => 'users/registrations' }

  root "home#top"
  get "about", to: "home#about"
  get "signout", to: "home#signout"

  resources :users
  resources :groups do
    resources :leagues
    resources :games
    resources :messages
  end


end
