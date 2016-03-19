Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'convos#index'

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  #get '/signup' => 'users#new'
  #post '/users' => 'users#create'

  #get '/about' => 'static_pages#about'
  get '/tos' => 'static_pages#tos'

  resources :topics

  resources :convos, path: '' do
    member do
      get 'upvote'
      get 'downvote'
    end
  end

  get '/topics/:topic_slug/:id/:convo_slug', to: 'convos#show', as: :convo_slug

  resources :comments do
    member do
      get 'upvote'
      get 'downvote'
    end
  end
  get '/topics/:topic_slug/:convo_id/:convo_slug/comment/:parent_id', to: 'comments#new', as: :comment_to_comment
end
