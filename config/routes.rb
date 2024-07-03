Rails.application.routes.draw do
  get 'users/show'
  get 'user/show'
  root "photos#index"

  devise_for :users

  resources :comments
  resources :follow_requests
  resources :likes
  resources :photos
  #resources :users, only: :show

  get ":username/liked" => "users#liked", as: :liked
  
  get ":username" => "users#show", as: :user

end
