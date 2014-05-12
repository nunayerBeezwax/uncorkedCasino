Rails.application.routes.draw do
  devise_for :users
 root to: "users#index"
  namespace :api do
    resources :games
  end

  resources :api_key
end
