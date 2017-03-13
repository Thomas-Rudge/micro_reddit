Rails.application.routes.draw do
  resources :users, only: [:destroy]

  get  '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  get '/user/:name', to: 'users#show'

  get '/post_title', to: 'meta_datas#get_title'

  get    '/r/:name',                 to: 'subreddits#show'
  get    '/subreddits/create',       to: 'subreddits#new'
  post   '/subreddits/create',       to: 'subreddits#create'
  get    '/subreddits/edit/:name',   to: 'subreddits#edit'
  post   '/subreddits/edit/:name',   to: 'subreddits#update'
  delete '/subreddits/delete/:name', to: 'subreddits#destroy'
  get    '/subreddits',              to: 'subreddits#index'

  get    '/submit',                to: 'posts#new'
  post   '/submit',                to: 'posts#create'
  get    '/r/:subreddit_name/:id', to: 'posts#show'
  delete '/r/:subreddit_name/:id', to: 'posts#destroy'
  get    '/post/:id/edit',         to: 'posts#edit'
  post   '/post/:id/edit',         to: 'posts#update'

  post   '/karma',                 to: 'karma#update'

  # Static pages
  get '/legal', to: 'static_pages#legal'
  get '/about', to: 'static_pages#about'

  root 'front_pages#index'
end
