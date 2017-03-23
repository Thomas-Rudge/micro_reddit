Rails.application.routes.draw do
  resources :users, only: [:destroy]

  get  '/signup',    to: 'users#new'
  post '/signup',    to: 'users#create'
  get '/user/:name', to: 'users#show'

  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  get    '/r/:name',                 to: 'subreddits#show'
  get    '/subreddits/create',       to: 'subreddits#new'
  post   '/subreddits/create',       to: 'subreddits#create'
  get    '/subreddits/edit/:name',   to: 'subreddits#edit'
  post   '/subreddits/edit/:name',   to: 'subreddits#update'
  delete '/subreddits/delete/:name', to: 'subreddits#destroy'
  get    '/subreddits',              to: 'subreddits#index'
  get    '/r',                       to: 'subreddits#index'

  get    '/submit',                to: 'posts#new'
  post   '/submit',                to: 'posts#create'
  get    '/r/:subreddit_name/:id', to: 'posts#show'
  delete '/r/:subreddit_name/:id', to: 'posts#destroy'
  get    '/post/:id/edit',         to: 'posts#edit'
  post   '/post/:id/edit',         to: 'posts#update'

  post   '/r/:subreddit_name/:post_id/comment', to: 'comments#create'

  post   '/subscribe',   to: 'subscriptions#create'
  post   '/unsubscribe', to: 'subscriptions#destroy'

  get  '/post_title', to: 'meta_datas#get_title'
  post '/karma',      to: 'votes#update'
  get  '/search',     to: 'search#new'

  # Static pages
  get '/legal', to: 'static_pages#legal'
  get '/about', to: 'static_pages#about'

  root 'front_pages#index'
end
