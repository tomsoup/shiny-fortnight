Rails.application.routes.draw do
  devise_for :users, :controllers => { :registrations => "user/registrations" }
  resources :user_stocks, except: [:show, :edit, :update]
  resources :users, only: [:show]
  resources :friendships
  root 'home#index'

  get 'my_portfolio', to: "users#my_portfolio"
  get 'search_stocks', to: "stocks#search"
  get 'friends', to: "users#friends"
  get 'search_friends', to: 'users#search'

  #POST because we are creating
  post 'add_friend', to: "users#add_friend"
end
