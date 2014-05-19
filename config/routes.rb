Rails.application.routes.draw do
 root to: "users#index"
  
  namespace :api do
    resources :games
    devise_for :users, controllers: { registrations: 'api/registrations', sessions: 'api/sessions'}
    resources :users, only: [:show, :update, :destroy]
    resources :houses
    resources :tables
    resources :api_keys, only: :create
  end

  resources :api_keys
end
