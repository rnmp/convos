Rails.application.routes.draw do

  get 'password_resets/new'

  get 'password_resets/edit'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'convos#index'

  resources :users
  get '/signup', to: 'users#new'
  
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  get '/activity', to: 'users#show'
  get '/settings', to: 'users#edit'

  get '/tos', to: 'static_pages#tos'

  post '/poll/:poll_id/:id/vote', to: 'polls#vote', as: :vote_on_poll

  resources :topics


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
