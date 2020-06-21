Rails.application.routes.draw do
  get 'statistics/index'
  get 'demo/index'
  post 'demo/start'
  post 'demo/stop'
  resources :matches
  resources :teams
  root to: 'demo#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
