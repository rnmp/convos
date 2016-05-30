Rails.application.routes.draw do

  get 'password_resets/new'

  get 'password_resets/edit'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'convos#index'

  resources :users
  get '/signup', to: 'users#new'
  
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  post '/yolo', to: 'sessions#create_for_test_user'
  get '/logout', to: 'sessions#destroy'

  get '/activity', to: 'users#show'
  get '/settings', to: 'users#edit'

  get '/about', to: 'static_pages#about'
  get '/tos', to: 'static_pages#tos'

  post '/poll/:poll_id/:id/vote', to: 'polls#vote', as: :vote_on_poll

  resources :topics

  get '/topics/:id/comments', to: 'topics#comments', as: :topic_comments


  resources :convos do
    member do
      get 'upvote'
      get 'downvote'
      post 'report'
    end
  end

  get '/topics/:topic_slug/:id/:convo_slug', to: 'convos#show', as: :convo_slug

  get '/notifications', to: 'notifications#index'

  resources :comments do
    member do
      get 'upvote'
      get 'downvote'
      post 'report'
    end
  end

  resources :password_resets, only: [:new, :create, :edit, :update]

end
