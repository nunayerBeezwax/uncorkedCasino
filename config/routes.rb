Rails.application.routes.draw do
 root to: "users#index"
# devise_for :users, controllers: { registrations: 'registrations' }
  
  namespace :api do
    resources :games
    devise_for :users, controllers: { registrations: 'api/registrations' }
    resources :users, only: [:show, :update, :destroy]
  end

  resources :api_keys
end
