Rails.application.routes.draw do
  devise_for :users

  root "home#top"
  get "about", to: "home#about"

  resources :groups do
    resources :leagues
  end


end
