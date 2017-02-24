Rails.application.routes.draw do
  resources :users, only: [:destroy]

  get    '/signup',    to: 'users#new'
  post   '/signup',    to: 'users#create'

  # Static pages
  get '/legal', to: 'static_pages#legal'
  get '/about', to: 'static_pages#about'

  root 'front_pages#index'
end
