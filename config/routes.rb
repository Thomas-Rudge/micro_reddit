Rails.application.routes.draw do
  resources :users, only: [:destroy]

  get    '/signup',    to: 'users#new'
  post   '/signup',    to: 'users#create'
end
