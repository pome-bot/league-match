Rails.application.routes.draw do
  devise_for :users

  root "home#top"
  get "about", to: "home#about"
  get "signout", to: "home#signout"

  resources :users
  resources :groups do
    resources :leagues
  end


end
