Rails.application.routes.draw do
  resources :users, only: [:destroy]

  get    '/signup',    to: 'users#new'
  post   '/signup',    to: 'users#create'

  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  # Static pages
  get '/legal', to: 'static_pages#legal'
  get '/about', to: 'static_pages#about'

  root 'front_pages#index'
end
