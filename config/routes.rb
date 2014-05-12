Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
 root to: "users#index"
  namespace :api do
    resources :games
  end

  resources :api_keys
end
